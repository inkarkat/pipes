#!/usr/bin/env bats

load fixture

@test "warning messages when changing two files" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "Warning: SUBJECT changed $FILE1
Warning: SUBJECT changed $FILE2" ]
    assertFile1Changed
    assertFile2Changed
}

@test "success no-change messages when no change on processing two files" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $FILE1 without changing it
Successfully performed SUBJECT on $FILE2 without changing it" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "success and warning message when change on second file" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $FILE1 without changing it
Warning: SUBJECT changed $FILE2" ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "warning and success no-change message when change on first file" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "Warning: SUBJECT changed $FILE1
Successfully performed SUBJECT on $FILE2 without changing it" ]
    assertFile1Changed
    assertFile2Unchanged
}

@test "failure and warning message when change on second file, and first file processing fails" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "ERROR: Failed to SUBJECT on $FILE1
Warning: SUBJECT changed $FILE2" ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "warning and failure message when change on first file, and second file processing fails" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "Warning: SUBJECT changed $FILE1
ERROR: Failed to SUBJECT on $FILE2" ]
    assertFile1Changed
    assertFile2Unchanged
}

@test "failure messages when all file processing fails" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "ERROR: Failed to SUBJECT on $FILE1
ERROR: Failed to SUBJECT on $FILE2" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "failure message when processing fails with 255" {
    run processEachFile --message-subject SUBJECT --warn-on-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 124 ]
    [ "$output" = "ERROR: Failed to SUBJECT on $FILE1" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

