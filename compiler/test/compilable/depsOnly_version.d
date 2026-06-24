/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only -version=UseA
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_version ($p:depsOnly_version.d$) : private : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
---
*/
module depsOnly_version;
version (UseA)
    import imports.depsOnly_basic_a;
else
    import imports.depsOnly_basic_b;
