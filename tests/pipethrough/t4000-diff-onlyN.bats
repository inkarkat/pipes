#!/usr/bin/env bats

load files

@test "two files with --diff-only" {
    run -0 pipethrough --diff-only --command "$commandSingleQuoted" "$foo" "$bar"
    assert_output - <<'EOF'
1c1
< FOO
---
> FOO FOO
1c1
< x
---
> x x
EOF
}

@test "two files with --diff-only unified diff" {
    type -t commandName >/dev/null || skip 'commandName is not available'

    origDate="$(stat --format=%y "$foo")"
    run -0 pipethrough --diff-only -u --command "$commandSingleQuoted" "$foo" "$bar"
    assert_line -n 0 "--- $foo ${origDate}"
    assert_line -n 1 "+++ $foo (after sed)"
    assert_line -n 2 '@@ -1 +1 @@'
    assert_line -n 3 '-FOO'
    assert_line -n 4 '+FOO FOO'

    assert_line -n 7 '@@ -1 +1 @@'
    assert_line -n 8 '-x'
    assert_line -n 9 '+x x'
}

@test "two files with --diff-only unified diff without commandName" {
    commandName() { false; }; export -f commandName

    origDate="$(stat --format=%y "$foo")"
    run -0 pipethrough --diff-only -u --command "$commandSingleQuoted" "$foo" "$bar"
    assert_line -n 0 "--- $foo ${origDate}"
    assert_line -n 1 "+++ $foo (after modifications)"
    assert_line -n 2 '@@ -1 +1 @@'
    assert_line -n 3 '-FOO'
    assert_line -n 4 '+FOO FOO'

    assert_line -n 7 '@@ -1 +1 @@'
    assert_line -n 8 '-x'
    assert_line -n 9 '+x x'
}

@test "two files with --diff-only unified diff with passed labels" {
    run -0 pipethrough --diff-only -u --label 'original' --label 'modified' --command "$commandSingleQuoted" "$foo" "$bar"
    assert_output - <<'EOF'
--- original
+++ modified
@@ -1 +1 @@
-FOO
+FOO FOO
--- original
+++ modified
@@ -1 +1 @@
-x
+x x
EOF
}
