#!/usr/bin/env bats

load fixture

@test "single command pipeline into sink command" {
    run -0 --separate-stderr pipelineWithDiff --sink-command "cat > ${OUTPUT_FILE@Q}" --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    diff -y "$OUTPUT_FILE" --label expected - <<<'Fi'
    assert_output ''
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "single command pipeline into multiple sink commands" {
    run -0 --separate-stderr pipelineWithDiff --sink-exec read line \; --sink-command 'test Fi = $line' --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    assert_output ''
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "multiple source commands into multiple sink commands" {
    run -0 --separate-stderr pipelineWithDiff --source-exec echo FOO \; --source-command 'echo BOO' --sink-exec read lineOne \; --sink-exec read lineTwo \; --sink-command 'test ${lineOne:1} = ${lineTwo:1}' --exec "${CHANGE_COMMAND[@]}" \;
    assert_output ''
    output="$stderr" assert_output - <<'EOF'
1,2c1,2
< FOO
< BOO
---
> Fi
> Bi
EOF
}

@test "sink command that suppresses input but produces its own output" {
    run -0 --separate-stderr pipelineWithDiff --sink-command 'cat >/dev/null; echo accepted; echo >&2 sink error' --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    assert_output 'accepted'
    output="$stderr" assert_output - <<'EOF'
sink error
1c1
< FOO
---
> Fi
EOF
}

@test "sink command that still passes through (partial) input" {
    run -0 --separate-stderr pipelineWithDiff --sink-exec grep B \; --exec "${CHANGE_COMMAND[@]}" \; <<'EOF'
FOO
BOO
EOF
    assert_output 'Bi'
    output="$stderr" assert_output - <<'EOF'
1,2c1,2
< FOO
< BOO
---
> Fi
> Bi
EOF
}
