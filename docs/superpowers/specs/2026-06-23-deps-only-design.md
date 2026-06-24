# Design: `-deps-only` — Fast Module Dependency Extraction for DMD

## Problem

The existing `-deps` flag runs the full compiler pipeline through semantic3,
inline scanning, code generation, and linking before outputting module
dependencies. For build systems that only need the import graph, this is
unnecessarily expensive.

## Goal

Add a `-deps-only` flag that produces the same import output as `-deps=<file>`
(depsImport lines) but skips all unnecessary compiler phases by walking the AST
with a lightweight visitor that runs semantics only where needed.

## Compiler Pipeline Changes

### Before (current):
```
CLI -> createModules -> read -> parse -> importAll -> backend_init
-> dsymbolSemantic -> semantic2 -> semantic3 -> inlineScan
-> codegen -> link -> [output deps]
```

### After (with `-deps-only`):
```
CLI -> createModules -> read -> parse -> importAll
-> [DepsCollectVisitor on each module] -> [output deps]
-> skip: backend_init, dsymbolSemantic, semantic2, semantic3, inline, codegen, link
```

## DepsCollectVisitor -- Core Design

A new `Visitor` subclass in `deps.d` that walks the parsed AST and evaluates
only what's needed.

### Visitor dispatch table

| AST node | Action | Semantic required |
|----------|--------|:---:|
| `Module` | Use `m._scope` (set by `importAll`), recurse members | No |
| `ScopeDsymbol` (class, struct, union, template decl, etc.) | Recurse into `members` | No |
| `AttribDeclaration` (non-Conditional) | Recurse into `decl` | No |
| `ConditionalDeclaration` (version/debug) | Call `expressionsem.include(condition, scope)` | Minimal |
| `StaticIfDeclaration` | Call `include(sif, sc)` which triggers `evalStaticCondition` -> `expressionSemantic` on condition only | **Condition only** |
| `StaticForeachDeclaration` | Call `include(sfd, sc)` for cached expansion | Minimal |
| `Import` | Call `addImportDep(moduleDeps, imp, sc._module)` | No |
| `PragmaDeclaration` | Recurse into `decl` | No |
| `TemplateDeclaration` | Walk `members` syntactically; for unresolvable static-if, report all branches conservatively | No |
| `FuncDeclaration`, `VarDeclaration`, `EnumMember`, etc. | Skip -- no recursion | None |

### Template Instantiation Handling

When the visitor encounters a declaration that references a template
instantiation (e.g. `alias X = Foo!(int)`):

1. A `depsOnly` flag (`global.params.depsOnly`) is set
2. The normal instantiation runs via `TemplateInstance.dsymbolSemantic()` up
   through member setup: args resolved, declaration found, body copied
3. `expandMembers()` runs `setScope` + `importAll` on instance members
4. At the `expandMembers` step, the flag is checked -- instead of
   `s.dsymbolSemantic(sc2)`, members are processed with `DepsCollectVisitor`
5. After `tryExpandMembers`, `semantic2`/`semantic3` are skipped
6. The instance body's imports are collected from the resulting AST

### Scope Management

`DepsCollectVisitor` stores a `Scope* sc` field, following the same pattern as
`DsymbolSemanticVisitor`. It uses `sc._module` as the `imod` parameter for
`addImportDep`.

For scope-creating nodes (`AttribDeclaration.newScope`, etc.), it follows the
existing pattern from `ImportAllVisitor` / `DsymbolSemanticVisitor`.

## Edge Cases

| Case | Handling |
|------|----------|
| `static if (is(T == int))` inside template | Condition contains template params -> evaluated during instantiation via `include()` |
| Nested imports in class body | `ScopeDsymbol.visit` recurses into `members` |
| `import()` expression | Skipped (expression-level only) |
| `mixin("import foo;")` | Cannot resolve without full semantic -- skipped |
| Template NOT instantiated | `TemplateDeclaration.members` walked syntactically; conservative over-reporting |
| `StaticForeachDeclaration` | `include(sfd, sc)` expands the loop |
| Circular imports | Import graph may have cycles -- `addImportDep` handles self-imports |

## Files Changed

| File | Change | ~Lines |
|------|--------|-------|
| `globals.d` | Add `bool depsOnly` to `Param` struct | 1 |
| `mars.d` | Parse `-deps-only` flag | 10 |
| `deps.d` | Add `DepsCollectVisitor` class | 150-200 |
| `templatesem.d` | Flag check in `expandMembers` + after `tryExpandMembers` | 15 |
| `main.d` | Gate pipeline phases; insert visitor call; skip backend/codegen/link | 25 |

## Testing

- Compare `-deps-only` output with `-deps=<file>` output on a representative
  corpus of D source files
- Should produce identical import lines (may produce more in conservative
  template cases)
- Test with templates, static-if, version/debug blocks, class-nested imports
