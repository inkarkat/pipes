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
    run -0 pipethrough1 --diff-only -u --command "$commandSingleQuoted" "$foo"
    assert_line -n 2 '@@ -1 +1 @@'
    assert_line -n 3 '-FOO'
    assert_line -n 4 '+FOO FOO'
}
