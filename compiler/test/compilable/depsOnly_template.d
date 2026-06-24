/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_basic_a.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_template ($p:depsOnly_template.d$) : private : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
---
*/
module depsOnly_template;
template HasImport(T)
{
    import imports.depsOnly_basic_a;
}
alias instance = HasImport!int;
