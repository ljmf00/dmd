/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_mixin_tmpl.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_mixin ($p:depsOnly_mixin.d$) : private : imports.depsOnly_mixin_tmpl ($p:depsOnly_mixin_tmpl.d$)
depsImport imports.depsOnly_mixin_tmpl ($p:depsOnly_mixin_tmpl.d$) : private : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
---*/
module depsOnly_mixin;
import imports.depsOnly_mixin_tmpl;
mixin MixinWithImport!int;
