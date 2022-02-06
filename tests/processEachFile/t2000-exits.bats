#!/usr/bin/env bats

load fixture

@test "successfully processing two files" {
    run processEachFile --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Changed
    assertFile2Changed
}

@test "no change on processing two files" {
    run processEachFile --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "first file processing fails" {
    run processEachFile --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "second file processing fails" {
    run processEachFile --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "" ]
    assertFile1Changed
    assertFile2Unchanged
}

@test "all file processing fails" {
    run processEachFile --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 123 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "processing fails with 255" {
    run processEachFile --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 124 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}
