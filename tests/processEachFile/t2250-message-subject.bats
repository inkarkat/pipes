#!/usr/bin/env bats

load fixture

@test "change messages for subject when successfully processing two files" {
    run -0 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
SUBJECT changed $FILE2
EOF
    assertFile1Changed
    assertFile2Changed
}

@test "abort message for subject when no change on processing two files" {
    run -1 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output "ERROR: Aborted because SUBJECT did not change $FILE1"
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "abort message for subject when no change on first file" {
    run -1 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output "ERROR: Aborted because SUBJECT did not change $FILE1"
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "change and abort messages for subject when no change on second file" {
    run -1 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
ERROR: Aborted because SUBJECT did not change $FILE2
EOF
    assertFile1Changed
    assertFile2Unchanged
}

@test "fail and change messages when first file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
ERROR: Failed to SUBJECT on $FILE1
SUBJECT changed $FILE2
EOF
    assertFile1Unchanged
    assertFile2Changed
}

@test "fail and change messages when second file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
ERROR: Failed to SUBJECT on $FILE2
EOF
    assertFile1Changed
    assertFile2Unchanged
}

@test "fail messages when all file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
ERROR: Failed to SUBJECT on $FILE1
ERROR: Failed to SUBJECT on $FILE2
EOF
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "fail message when processing fails with 255" {
    run -124 processEachFile --message-subject SUBJECT --abort-unless-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output "ERROR: Failed to SUBJECT on $FILE1"
    assertFile1Unchanged
    assertFile2Unchanged
}
