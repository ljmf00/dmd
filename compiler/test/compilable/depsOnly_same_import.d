/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_basic_a.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_same_import (compilable$?:windows=\\|/$depsOnly_same_import.d) : private : imports.depsOnly_basic_a (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_basic_a.d)
depsImport depsOnly_same_import (compilable$?:windows=\\|/$depsOnly_same_import.d) : private : imports.depsOnly_basic_a (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_basic_a.d)
---
*/
module depsOnly_same_import;
import imports.depsOnly_basic_a;
import imports.depsOnly_basic_a;
