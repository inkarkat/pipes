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
    run -0 pipethrough --diff-only -u --command "$commandSingleQuoted" "$foo" "$bar"
    assert_line -n 2 '@@ -1 +1 @@'
    assert_line -n 3 '-FOO'
    assert_line -n 4 '+FOO FOO'
    assert_line -n 7 '@@ -1 +1 @@'
    assert_line -n 8 '-x'
    assert_line -n 9 '+x x'
}
