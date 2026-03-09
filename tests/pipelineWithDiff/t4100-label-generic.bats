#!/usr/bin/env bats

load fixture

setup() {
    commandName() { false; }; export -f commandName
}

@test "unified diff shows generic header" {
    run -0 --separate-stderr pipelineWithDiff -u --exec "${changeCommand[@]}" \; <<<'FOO'
    lines=("${stderr_lines[@]}")
    assert_line -n 0 '--- input'
    assert_line -n 1 '+++ output (after modifications)'
}

@test "unified diff shows generic source and pipeline header" {
    run -0 --separate-stderr pipelineWithDiff -u --source-exec echo FOO \; --exec "${changeCommand[@]}" \;
    lines=("${stderr_lines[@]}")
    assert_line -n 0 '--- input (from source command)'
    assert_line -n 1 '+++ output (after modifications)'
}
