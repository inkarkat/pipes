#!/usr/bin/env bats

load fixture

@test "no failure messages when successfully processing two files" {
    run processEachFile --message-on-failure FAIL --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Changed
    assertFile2Changed
}

@test "no failure messages when no change on processing two files" {
    run processEachFile --message-on-failure FAIL --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "one failure message when first file processing fails" {
    run processEachFile --message-on-failure FAIL --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = 'FAIL' ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "one failure message when second file processing fails" {
    run processEachFile --message-on-failure FAIL --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = 'FAIL' ]
    assertFile1Changed
    assertFile2Unchanged
}

@test "failure messages when all file processing fails" {
    run processEachFile --message-on-failure FAIL --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = $'FAIL\nFAIL' ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "failure messages when processing fails with 255" {
    run processEachFile --message-on-failure FAIL --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 124 ]
    [ "$output" = 'FAIL' ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "failure messages with embedded file when all file processing fails" {
    run processEachFile --message-on-failure 'FAIL for %q' --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "FAIL for $FILE1
FAIL for $FILE2" ]
    assertFile1Unchanged
    assertFile2Unchanged
}
