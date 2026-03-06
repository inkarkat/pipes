#!/usr/bin/env bats

load files

@test "two files with --diff" {
    run -0 pipethrough --diff --command "$commandSingleQuoted" "$foo" "$bar"
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

@test "two files with --diff unified diff" {
    origDate="$(stat --format=%y "$foo")"
    run -0 pipethrough --diff -u --command "$commandSingleQuoted" "$foo" "$bar"
    assert_line -n 0 "--- $foo ${origDate}"
    assert_line -n 1 "+++ $foo $(stat --format=%y "$foo")"
    assert_line -n 2 '@@ -1 +1 @@'
    assert_line -n 3 '-FOO'
    assert_line -n 4 '+FOO FOO'

    assert_line -n 7 '@@ -1 +1 @@'
    assert_line -n 8 '-x'
    assert_line -n 9 '+x x'
}

@test "two files with --diff unified diff with passed labels" {
    run -0 pipethrough --diff -u --label 'original' --label 'modified' --command "$commandSingleQuoted" "$foo" "$bar"
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
