/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_visibility ($p:depsOnly_visibility.d$) : public : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
depsImport depsOnly_visibility ($p:depsOnly_visibility.d$) : private : imports.depsOnly_basic_b ($p:depsOnly_basic_b.d$)
---
*/
module depsOnly_visibility;
public import imports.depsOnly_basic_a;
private import imports.depsOnly_basic_b;
