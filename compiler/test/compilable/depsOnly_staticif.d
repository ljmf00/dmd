/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_staticif ($p:depsOnly_staticif.d$) : private : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
---
*/
module depsOnly_staticif;
static if (true)
    import imports.depsOnly_basic_a;
else
    import imports.depsOnly_basic_b;
