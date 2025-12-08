#!/usr/bin/env bats

load fixture

@test "abort when changing two files" {
    run -1 processEachFile --abort-on-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "no abort when no change on processing two files" {
    run -0 processEachFile --abort-on-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "abort when change on second file" {
    run -1 processEachFile --abort-on-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_changed
}

@test "abort when change on first file" {
    run -1 processEachFile --abort-on-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "abort when change on second file, and first file processing fails" {
    run -1 processEachFile --abort-on-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_changed
}

@test "abort when change on first file, and second file processing fails" {
    run -1 processEachFile --abort-on-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "no abort when all file processing fails" {
    run -123 processEachFile --abort-on-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "no abort when processing fails with 255" {
    run -124 processEachFile --abort-on-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}
