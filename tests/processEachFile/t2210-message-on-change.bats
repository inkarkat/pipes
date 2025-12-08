#!/usr/bin/env bats

load fixture

@test "change messages when successfully processing two files" {
    run -0 processEachFile --message-on-change CHANGE --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output $'CHANGE\nCHANGE'
    assertFile1Changed
    assertFile2Changed
}

@test "no change messages when no change on processing two files" {
    run -0 processEachFile --message-on-change CHANGE --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "one change message when first file processing fails" {
    run -123 processEachFile --message-on-change CHANGE --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'CHANGE'
    assertFile1Unchanged
    assertFile2Changed
}

@test "one change message when second file processing fails" {
    run -123 processEachFile --message-on-change CHANGE --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'CHANGE'
    assertFile1Changed
    assertFile2Unchanged
}

@test "no change messages when all file processing fails" {
    run -123 processEachFile --message-on-change CHANGE --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "no change messages when processing fails with 255" {
    run -124 processEachFile --message-on-change CHANGE --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "change messages with embedded file when successfully processing two files" {
    run -0 processEachFile --message-on-change 'CHANGE for %q' --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
CHANGE for $FILE1
CHANGE for $FILE2
EOF
    assertFile1Changed
    assertFile2Changed
}
