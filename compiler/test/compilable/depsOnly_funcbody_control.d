/*
PERMUTE_ARGS:
REQUIRED_ARGS: -deps-only
EXTRA_SOURCES: imports/depsOnly_basic_a.d imports/depsOnly_basic_b.d imports/depsOnly_basic_c.d
TRANSFORM_OUTPUT: remove_lines("druntime")
TEST_OUTPUT:
---
depsImport depsOnly_funcbody_control ($p:depsOnly_funcbody_control.d$) : private : imports.depsOnly_basic_a ($p:depsOnly_basic_a.d$)
depsImport depsOnly_funcbody_control ($p:depsOnly_funcbody_control.d$) : private : imports.depsOnly_basic_b ($p:depsOnly_basic_b.d$)
depsImport depsOnly_funcbody_control ($p:depsOnly_funcbody_control.d$) : private : imports.depsOnly_basic_c ($p:depsOnly_basic_c.d$)
---
*/
module depsOnly_funcbody_control;
void testIf(bool cond)
{
    if (cond)
        import imports.depsOnly_basic_a;
}

void testWhile()
{
    while (false)
        import imports.depsOnly_basic_b;
}

void testFor()
{
    for (; false; )
        import imports.depsOnly_basic_c;
}
