/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_staticif_else ($p:depsOnly_staticif_else.d$) : private : imports.depsOnly_basic_b ($p:depsOnly_basic_b.d$)
---
*/
module depsOnly_staticif_else;
static if (false)
    import imports.depsOnly_basic_a;
else
    import imports.depsOnly_basic_b;
