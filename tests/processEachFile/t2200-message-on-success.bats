#!/usr/bin/env bats

load fixture

@test "message on successfully processing two files" {
    run -0 processEachFile --message-on-success SUCCESS --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output $'SUCCESS\nSUCCESS'
    assert_FILE1_changed
    assert_FILE2_changed
}

@test "success messages no change on processing two files" {
    run -0 processEachFile --message-on-success SUCCESS --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output $'SUCCESS\nSUCCESS'
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "one success message when first file processing fails" {
    run -123 processEachFile --message-on-success SUCCESS --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'SUCCESS'
    assert_FILE1_unchanged
    assert_FILE2_changed
}

@test "one success message when second file processing fails" {
    run -123 processEachFile --message-on-success SUCCESS --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'SUCCESS'
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "no success message when all file processing fails" {
    run -123 processEachFile --message-on-success SUCCESS --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "no success message when processing fails with 255" {
    run -124 processEachFile --message-on-success SUCCESS --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "message with embedded files on successfully processing two files" {
    run -0 processEachFile --message-on-success 'SUCCESS for %q' --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUCCESS for $FILE1
SUCCESS for $FILE2
EOF
    assert_FILE1_changed
    assert_FILE2_changed
}
