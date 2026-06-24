/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only -v
EXTRA_SOURCES: imports/depsOnly_basic_a.d
TRANSFORM_OUTPUT: remove_lines("druntime") remove_lines("^\(") remove_lines("^(predefs|parse|import|deps-only|binary|version|config|DFLAGS)")
TEST_OUTPUT:
---
depsImport depsOnly_verbose (compilable$?:windows=\\|/$depsOnly_verbose.d) : private : imports.depsOnly_basic_a (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_basic_a.d)
---
*/
module depsOnly_verbose;
import imports.depsOnly_basic_a;
