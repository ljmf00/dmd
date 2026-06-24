/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_scope ($p:depsOnly_scope.d$) : private : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
depsImport depsOnly_scope ($p:depsOnly_scope.d$) : private : imports.depsOnly_basic_b ($p:depsOnly_basic_b.d$)
---
*/
module depsOnly_scope;
class MyClass
{
    import imports.depsOnly_basic_a;
}
struct MyStruct
{
    import imports.depsOnly_basic_b;
}
template MyTemplate()
{
    import imports.depsOnly_basic_c;
}
