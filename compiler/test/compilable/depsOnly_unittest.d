/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only -unittest
EXTRA_SOURCES: imports/depsOnly_basic_a.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_unittest (compilable$?:windows=\\|/$depsOnly_unittest.d) : private : imports.depsOnly_basic_a (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_basic_a.d)
---
*/
module depsOnly_unittest;
unittest
{
    import imports.depsOnly_basic_a;
}
