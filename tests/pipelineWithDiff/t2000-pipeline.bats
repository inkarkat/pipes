#!/usr/bin/env bats

load fixture

@test "single command pipeline modifies input" {
    run -0 --separate-stderr pipelineWithDiff --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    assert_output 'Fi'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "no-op pipeline does no change input" {
    run -0 --separate-stderr pipelineWithDiff --exec "${NOOP_COMMAND[@]}" \; <<<'FOO'
    assert_output 'FOO'
    output="$stderr" assert_output ''
}

@test "failing pipeline exit status is returned" {
    run -1 --separate-stderr pipelineWithDiff --exec "${FAIL_COMMAND[@]}" \; <<<'FOO'
    assert_output 'FOO'
    output="$stderr" assert_output ''
}

@test "modifying and failing pipeline shows diff and returns failure status" {
    run -42 --separate-stderr pipelineWithDiff --exec "${MODIFY_AND_FAIL_COMMAND[@]}" \; <<<'FOO'
    assert_output 'Fi'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}
