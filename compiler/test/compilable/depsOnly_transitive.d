/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_trans_a.d imports/depsOnly_trans_b.d imports/depsOnly_trans_c.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_transitive (compilable$?:windows=\\|/$depsOnly_transitive.d) : private : imports.depsOnly_trans_a (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_trans_a.d)
depsImport imports.depsOnly_trans_a (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_trans_a.d) : private : imports.depsOnly_trans_b (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_trans_b.d)
depsImport imports.depsOnly_trans_b (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_trans_b.d) : private : imports.depsOnly_trans_c (compilable$?:windows=\\|/$imports$?:windows=\\|/$depsOnly_trans_c.d)
---
*/
module depsOnly_transitive;
import imports.depsOnly_trans_a;
