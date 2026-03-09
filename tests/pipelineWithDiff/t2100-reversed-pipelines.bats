#!/usr/bin/env bats

load fixture

@test "three commands modify input from left to right" {
    run -0 --separate-stderr pipelineWithDiff --exec "${changeCommand[@]}" \; --exec "${duplicateCommand[@]}" \; --exec "${braceCommand[@]}" \; <<<'FOO'
    assert_output '[FiFi]'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> [FiFi]
EOF
}

@test "two exec and one appended commands modify input from left to right" {
    run -0 --separate-stderr pipelineWithDiff --exec "${changeCommand[@]}" \; --exec "${duplicateCommand[@]}" \; -- "${braceCommand[@]}" <<<'FOO'
    assert_output '[FiFi]'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> [FiFi]
EOF
}

@test "three reversed commands modify input from right to left" {
    run -0 --separate-stderr pipelineWithDiff --reverse --exec "${changeCommand[@]}" \; --exec "${duplicateCommand[@]}" \; --exec "${braceCommand[@]}" \; <<<'FOO'
    assert_output '[Fi][FOO]'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> [Fi][FOO]
EOF
}

@test "last reversed command is applied first" {
    run -0 --separate-stderr pipelineWithDiff --exec "${changeCommand[@]}" \; --exec "${duplicateCommand[@]}" \; --reverse "${braceCommand[@]}" <<<'FOO'
    assert_output '[Fi][Fi]'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> [Fi][Fi]
EOF
}
