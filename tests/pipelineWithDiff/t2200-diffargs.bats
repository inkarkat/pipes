#!/usr/bin/env bats

load fixture

@test "unified diff" {
    run -0 --separate-stderr pipelineWithDiff -u --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    assert_output 'Fi'
    lines=("${stderr_lines[@]}")
    assert_line -n -3 '@@ -1 +1 @@'
    assert_line -n -2 '-FOO'
    assert_line -n -1 '+Fi'
}
