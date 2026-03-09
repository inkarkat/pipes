#!/usr/bin/env bats

load fixture

setup() {
    fixtureSetup
    type -t commandName >/dev/null || skip 'commandName is not available'
}

@test "unified diff shows pipeline command in header" {
    run -0 --separate-stderr pipelineWithDiff -u --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    lines=("${stderr_lines[@]}")
    assert_line -n 0 '--- input'
    assert_line -n 1 '+++ output (after sed)'
}

@test "unified diff shows source and pipeline commands in header" {
    run -0 --separate-stderr pipelineWithDiff -u --source-exec echo FOO \; --exec "${CHANGE_COMMAND[@]}" \;
    lines=("${stderr_lines[@]}")
    assert_line -n 0 '--- input (from echo)'
    assert_line -n 1 '+++ output (after sed)'
}
