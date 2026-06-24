/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_circ_a.d imports/depsOnly_circ_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_circular ($p:depsOnly_circular.d$) : private : imports.depsOnly_circ_a ($p:depsOnly_circ_a.d$)
depsImport imports.depsOnly_circ_a ($p:depsOnly_circ_a.d$) : private : imports.depsOnly_circ_b ($p:depsOnly_circ_b.d$)
depsImport imports.depsOnly_circ_b ($p:depsOnly_circ_b.d$) : private : imports.depsOnly_circ_a ($p:depsOnly_circ_a.d$)
---
*/
module depsOnly_circular;
import imports.depsOnly_circ_a;
