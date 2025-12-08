#!/usr/bin/env bats

load fixture

@test "no failure messages when successfully processing two files" {
    run -0 processEachFile --message-on-failure FAIL --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_changed
    assert_FILE2_changed
}

@test "no failure messages when no change on processing two files" {
    run -0 processEachFile --message-on-failure FAIL --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "one failure message when first file processing fails" {
    run -123 processEachFile --message-on-failure FAIL --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'FAIL'
    assert_FILE1_unchanged
    assert_FILE2_changed
}

@test "one failure message when second file processing fails" {
    run -123 processEachFile --message-on-failure FAIL --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'FAIL'
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "failure messages when all file processing fails" {
    run -123 processEachFile --message-on-failure FAIL --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output $'FAIL\nFAIL'
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "failure messages when processing fails with 255" {
    run -124 processEachFile --message-on-failure FAIL --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output 'FAIL'
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "failure messages with embedded file when all file processing fails" {
    run -123 processEachFile --message-on-failure 'FAIL for %q' --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
FAIL for $FILE1
FAIL for $FILE2
EOF
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}
