#!/usr/bin/env bats

load fixture

@test "message on successfully processing two files" {
    run processEachFile --message-on-success SUCCESS --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = $'SUCCESS\nSUCCESS' ]
    assertFile1Changed
    assertFile2Changed
}

@test "success messages no change on processing two files" {
    run processEachFile --message-on-success SUCCESS --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = $'SUCCESS\nSUCCESS' ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "one success message when first file processing fails" {
    run processEachFile --message-on-success SUCCESS --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = 'SUCCESS' ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "one success message when second file processing fails" {
    run processEachFile --message-on-success SUCCESS --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = 'SUCCESS' ]
    assertFile1Changed
    assertFile2Unchanged
}

@test "no success message when all file processing fails" {
    run processEachFile --message-on-success SUCCESS --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "no success message when processing fails with 255" {
    run processEachFile --message-on-success SUCCESS --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 124 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "message with embedded files on successfully processing two files" {
    run processEachFile --message-on-success 'SUCCESS for %q' --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "SUCCESS for $FILE1
SUCCESS for $FILE2" ]
    assertFile1Changed
    assertFile2Changed
}
