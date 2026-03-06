#!/usr/bin/env bats

load files

@test "file with --diff-only" {
    run -0 pipethrough1 --diff-only --command "$commandSingleQuoted" "$foo"
    assert_output - <<'EOF'
1c1
< FOO
---
> FOO FOO
EOF
}

@test "file with --diff-only unified diff" {
    type -t commandName >/dev/null || skip 'commandName is not available'

    origDate="$(stat --format=%y "$foo")"
    run -0 pipethrough1 --diff-only -u --command "$commandSingleQuoted" "$foo"
    assert_output - <<EOF
--- $foo $origDate
+++ $foo (after sed)
@@ -1 +1 @@
-FOO
+FOO FOO
EOF
}

@test "file with --diff-only unified diff without commandName" {
    commandName() { false; }; export -f commandName

    origDate="$(stat --format=%y "$foo")"
    run -0 pipethrough1 --diff-only -u --command "$commandSingleQuoted" "$foo"
    assert_output - <<EOF
--- $foo $origDate
+++ $foo (after modifications)
@@ -1 +1 @@
-FOO
+FOO FOO
EOF
}

@test "file with --diff-only unified diff with passed labels" {
    run -0 pipethrough1 --diff-only -u --label 'original' --label 'modified' --command "$commandSingleQuoted" "$foo"
    assert_output - <<'EOF'
--- original
+++ modified
@@ -1 +1 @@
-FOO
+FOO FOO
EOF
}
