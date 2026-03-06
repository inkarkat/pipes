#!/usr/bin/env bats

load files

@test "file with --diff" {
    run -0 pipethrough1 --diff --command "$commandSingleQuoted" "$foo"
    assert_output - <<'EOF'
1c1
< FOO
---
> FOO FOO
EOF
}

@test "file with --diff unified diff" {
    origDate="$(stat --format=%y "$foo")"
    run -0 pipethrough1 --diff -u --command "$commandSingleQuoted" "$foo"
    assert_output - <<EOF
--- $foo ${origDate}
+++ $foo $(stat --format=%y "$foo")
@@ -1 +1 @@
-FOO
+FOO FOO
EOF
}

@test "file with --diff unified diff with passed labels" {
    run -0 pipethrough1 --diff -u --label 'original' --label 'modified' --command "$commandSingleQuoted" "$foo"
    assert_output - <<'EOF'
--- original
+++ modified
@@ -1 +1 @@
-FOO
+FOO FOO
EOF
}
