/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only -version=Outer -version=Inner
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_nested_cond ($p:depsOnly_nested_cond.d$) : private : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
---
*/
module depsOnly_nested_cond;
version (Outer)
{
    version (Inner)
        import imports.depsOnly_basic_a;
    else
        import imports.depsOnly_basic_b;
}
else
    import imports.depsOnly_basic_c;
