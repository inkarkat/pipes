#!/usr/bin/env bats

load fixture

@test "warning messages when changing two files" {
    run -0 processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Warning: SUBJECT changed $FILE1
Warning: SUBJECT changed $FILE2
EOF
    assert_FILE1_changed
    assert_FILE2_changed
}

@test "success no-change messages when no change on processing two files" {
    run -0 processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Successfully performed SUBJECT on $FILE1 without changing it
Successfully performed SUBJECT on $FILE2 without changing it
EOF
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "success and warning message when change on second file" {
    run -0 processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Successfully performed SUBJECT on $FILE1 without changing it
Warning: SUBJECT changed $FILE2
EOF
    assert_FILE1_unchanged
    assert_FILE2_changed
}

@test "warning and success no-change message when change on first file" {
    run -0 processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Warning: SUBJECT changed $FILE1
Successfully performed SUBJECT on $FILE2 without changing it
EOF
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "failure and warning message when change on second file, and first file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --warn-on-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
ERROR: Failed to SUBJECT on $FILE1
Warning: SUBJECT changed $FILE2
EOF
    assert_FILE1_unchanged
    assert_FILE2_changed
}

@test "warning and failure message when change on first file, and second file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --warn-on-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Warning: SUBJECT changed $FILE1
ERROR: Failed to SUBJECT on $FILE2
EOF
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "failure messages when all file processing fails" {
    run -123 processEachFile --message-subject SUBJECT --warn-on-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
ERROR: Failed to SUBJECT on $FILE1
ERROR: Failed to SUBJECT on $FILE2
EOF
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "failure message when processing fails with 255" {
    run -124 processEachFile --message-subject SUBJECT --warn-on-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output "ERROR: Failed to SUBJECT on $FILE1"
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

