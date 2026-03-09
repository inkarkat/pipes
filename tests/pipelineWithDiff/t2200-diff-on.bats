#!/usr/bin/env bats

load fixture

@test "by default, diff on command success" {
    run -0 --separate-stderr pipelineWithDiff --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "by default, diff on failing command" {
    run -42 --separate-stderr pipelineWithDiff --exec "${MODIFY_AND_FAIL_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "diff on command success with --diff-on-success" {
    run -0 --separate-stderr pipelineWithDiff --diff-on-success --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "diff on failing command with --diff-on-failure" {
    run -42 --separate-stderr pipelineWithDiff --diff-on-failure --exec "${MODIFY_AND_FAIL_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "no diff on command success with --diff-on-failure" {
    run -0 --separate-stderr pipelineWithDiff --diff-on-failure --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output ''
}

@test "no diff on failing command with --diff-on-success" {
    run -42 --separate-stderr pipelineWithDiff --diff-on-success --exec "${MODIFY_AND_FAIL_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output ''
}

@test "diff on failing command with --diff-on 42" {
    run -42 --separate-stderr pipelineWithDiff --diff-on 42 --exec "${MODIFY_AND_FAIL_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "diff on failing command with --diff-unless 1" {
    run -42 --separate-stderr pipelineWithDiff --diff-unless 1 --exec "${MODIFY_AND_FAIL_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "no diff on failing command with --diff-unless 42" {
    run -42 --separate-stderr pipelineWithDiff --diff-unless 42 --exec "${MODIFY_AND_FAIL_COMMAND[@]}" \; <<<'FOO'
    output="$stderr" assert_output ''
}
