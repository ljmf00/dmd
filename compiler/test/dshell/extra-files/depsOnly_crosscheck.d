module depsOnly_crosscheck;

import core.stdc.stdio;
version (UseExtra)
    import core.stdc.stdlib;

class Foo
{
    import core.stdc.string;
}

void test()
{
    import core.stdc.signal;
}
