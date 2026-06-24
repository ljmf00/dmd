/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only -version=UseB
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_version_else ($p:depsOnly_version_else.d$) : private : imports.depsOnly_basic_b ($p:depsOnly_basic_b.d$)
---
*/
module depsOnly_version_else;
version (UseA)
    import imports.depsOnly_basic_a;
else
    import imports.depsOnly_basic_b;
