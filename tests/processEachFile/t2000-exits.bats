#!/usr/bin/env bats

load fixture

@test "successfully processing two files" {
    run -0 processEachFile --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Changed
    assertFile2Changed
}

@test "no change on processing two files" {
    run -0 processEachFile --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "first file processing fails" {
    run -123 processEachFile --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Changed
}

@test "second file processing fails" {
    run -123 processEachFile --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Changed
    assertFile2Unchanged
}

@test "all file processing fails" {
    run -123 processEachFile --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "processing fails with 255" {
    run -124 processEachFile --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}
