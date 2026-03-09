#!/usr/bin/env bats

load fixture

@test "output to FILE shows diff on stdout" {
    run -0 --separate-stderr pipelineWithDiff --output "$OUTPUT_FILE" --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    diff -y "$OUTPUT_FILE" --label expected - <<<'Fi'
    assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "diff to FILE shows modifications on stdout" {
    run -0 --separate-stderr pipelineWithDiff --diff-output "$OUTPUT_FILE" --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    assert_output 'Fi'
    diff -y "$OUTPUT_FILE" --label expected - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "appended output to FILE shows diff on stdout" {
    run -0 --separate-stderr pipelineWithDiff --output "$OUTPUT_FILE" --append --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    diff -y "$OUTPUT_FILE" --label expected - <<'EOF'
EXISTING CONTENTS
Fi
EOF
    assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "appended diff to FILE shows modifications on stdout" {
    run -0 --separate-stderr pipelineWithDiff --diff-output "$OUTPUT_FILE" --append --exec "${CHANGE_COMMAND[@]}" \; <<<'FOO'
    assert_output 'Fi'
    diff -y "$OUTPUT_FILE" --label expected - <<'EOF'
EXISTING CONTENTS
1c1
< FOO
---
> Fi
EOF
}
