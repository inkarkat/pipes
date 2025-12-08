#!/usr/bin/env bats

load fixture

@test "no warning messages when successfully processing two files" {
    run -0 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
SUBJECT changed $FILE2
EOF
    assertFile1Changed
    assertFile2Changed
}

@test "warning messages when no change on processing two files" {
    run -0 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Warning: SUBJECT did not change $FILE1
Warning: SUBJECT did not change $FILE2
EOF
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "warning and change message when no change on first file" {
    run -0 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Warning: SUBJECT did not change $FILE1
SUBJECT changed $FILE2
EOF
    assertFile1Unchanged
    assertFile2Changed
}

@test "change and warning message when no change on second file" {
    run -0 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
Warning: SUBJECT did not change $FILE2
EOF
    assertFile1Changed
    assertFile2Unchanged
}

@test "failure and change message when first file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
ERROR: Failed to SUBJECT on $FILE1
SUBJECT changed $FILE2
EOF
    assertFile1Unchanged
    assertFile2Changed
}

@test "change and failure message when second file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
ERROR: Failed to SUBJECT on $FILE2
EOF
    assertFile1Changed
    assertFile2Unchanged
}

@test "no abort message when all file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
ERROR: Failed to SUBJECT on $FILE1
ERROR: Failed to SUBJECT on $FILE2
EOF
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "failure message when processing fails with 255" {
    run -124 processEachFile --message-subject SUBJECT --warn-unless-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output "ERROR: Failed to SUBJECT on $FILE1"
    assertFile1Unchanged
    assertFile2Unchanged
}
