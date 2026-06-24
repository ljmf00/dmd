import dshell;

void runTest(string label, string src)
{
    Vars.set("deps_file", "$OUTPUT_BASE/compile.deps");
    Vars.set("deps_only_file", "$OUTPUT_BASE/compile.deps_only");
    Vars.set("test_src_file", "$OUTPUT_BASE/test_src.d");

    std.file.write(Vars.test_src_file, src);

    // Compile with -deps to stdout (both outputs use same format)
    auto depsOutFile = std.stdio.File(Vars.deps_file, "w");
    run([DMD(), "-m" ~ MODEL(), "-deps", "-", "-c", Vars.test_src_file],
        depsOutFile, std.stdio.stderr);
    depsOutFile.close();
    if (!exists(Vars.deps_file))
        assert(0, label ~ ": deps file should exist");

    // Compile with -deps-only, capture stdout to file
    auto depsOnlyOutFile = std.stdio.File(Vars.deps_only_file, "w");
    run([DMD(), "-m" ~ MODEL(), "-deps-only", "-c", Vars.test_src_file],
        depsOnlyOutFile, std.stdio.stderr);
    depsOnlyOutFile.close();
    if (!exists(Vars.deps_only_file))
        assert(0, label ~ ": deps-only file missing");

    // Read both outputs
    auto depsContent = readText(Vars.deps_file);
    auto depsOnlyContent = readText(Vars.deps_only_file);

    foreach (line; depsOnlyContent.splitLines())
    {
        if (line.length > 0)
        {
            if (depsContent.indexOf(line) == -1)
                assert(0, label ~ ": deps-only line not found in -deps:\n" ~ line);
        }
    }
}

void main()
{
    runTest("basic import",
        "module cross_a;\n" ~
        "import core.stdc.stdio;\n");

    runTest("function body import",
        "module cross_b;\n" ~
        "void foo() {\n" ~
        "    import core.stdc.stdio;\n" ~
        "}\n");

    runTest("class scope import",
        "module cross_c;\n" ~
        "class Foo {\n" ~
        "    import core.stdc.stdio;\n" ~
        "}\n");

    runTest("version conditional",
        "module cross_d;\n" ~
        "version (linux) {\n" ~
        "    import core.stdc.stdlib;\n" ~
        "}\n");

    runTest("static if",
        "module cross_e;\n" ~
        "static if (true) {\n" ~
        "    import core.stdc.stdio;\n" ~
        "}\n");

    runTest("unittest import",
        "module cross_f;\n" ~
        "unittest {\n" ~
        "    import core.stdc.stdio;\n" ~
        "}\n");

    runTest("public import",
        "module cross_g;\n" ~
        "public import core.stdc.stdio;\n");
}
