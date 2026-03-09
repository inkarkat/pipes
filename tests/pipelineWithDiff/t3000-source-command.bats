#!/usr/bin/env bats

load fixture

@test "source command into single command pipeline" {
    run -0 --separate-stderr pipelineWithDiff --source-exec echo FOO \; --exec "${changeCommand[@]}" \;
    assert_output 'Fi'
    output="$stderr" assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "multiple source commands into single command pipeline" {
    run -0 --separate-stderr pipelineWithDiff --source-exec echo FOO \; --source-command 'echo BOO' --exec "${changeCommand[@]}" \;
    assert_output - <<'EOF'
Fi
Bi
EOF
    output="$stderr" assert_output - <<'EOF'
1,2c1,2
< FOO
< BOO
---
> Fi
> Bi
EOF
}
