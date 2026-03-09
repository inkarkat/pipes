#!/usr/bin/env bats

load fixture

@test "unified diff" {
    type -t commandName >/dev/null || skip 'commandName is not available'

    run -0 --separate-stderr pipelineWithDiff -u --exec "${changeCommand[@]}" \; <<<'FOO'
    assert_output 'Fi'
    output="$stderr" assert_output - <<'EOF'
--- input
+++ output (after sed)
@@ -1 +1 @@
-FOO
+Fi
EOF
}

@test "unified diff without commandName" {
    commandName() { false; }; export -f commandName

    run -0 --separate-stderr pipelineWithDiff -u --exec "${changeCommand[@]}" \; <<<'FOO'
    assert_output 'Fi'
    output="$stderr" assert_output - <<'EOF'
--- input
+++ output (after modifications)
@@ -1 +1 @@
-FOO
+Fi
EOF
}
