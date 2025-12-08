#!/usr/bin/env bats

load fixture

@test "no abort when successfully processing two files" {
    run -0 processEachFile --abort-unless-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_changed
    assert_FILE2_changed
}

@test "abort when no change on processing two files" {
    run -1 processEachFile --abort-unless-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "abort when no change on first file" {
    run -1 processEachFile --abort-unless-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "abort when no change on second file" {
    run -1 processEachFile --abort-unless-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "no abort when first file processing fails" {
    run -123 processEachFile --abort-unless-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_changed
}

@test "no abort when second file processing fails" {
    run -123 processEachFile --abort-unless-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_changed
    assert_FILE2_unchanged
}

@test "no abort when all file processing fails" {
    run -123 processEachFile --abort-unless-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "no abort when processing fails with 255" {
    run -124 processEachFile --abort-unless-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}
