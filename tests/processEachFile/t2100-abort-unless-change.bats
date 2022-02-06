#!/usr/bin/env bats

load fixture

@test "no abort when successfully processing two files" {
    run processEachFile --abort-unless-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Changed
    assertFile2Changed
}

@test "abort when no change on processing two files" {
    run processEachFile --abort-unless-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "abort when no change on first file" {
    run processEachFile --abort-unless-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "abort when no change on second file" {
    run processEachFile --abort-unless-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    assertFile1Changed
    assertFile2Unchanged
}

@test "no abort when first file processing fails" {
    run processEachFile --abort-unless-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "no abort when second file processing fails" {
    run processEachFile --abort-unless-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "" ]
    assertFile1Changed
    assertFile2Unchanged
}

@test "no abort when all file processing fails" {
    run processEachFile --abort-unless-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "no abort when processing fails with 255" {
    run processEachFile --abort-unless-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 124 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}
