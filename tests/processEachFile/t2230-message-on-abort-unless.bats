#!/usr/bin/env bats

load fixture

@test "no abort messages when successfully processing two files" {
    run -0 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Changed
    assertFile2Changed
}

@test "abort message when no change on processing two files" {
    run -1 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'ABORT'
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "abort message when no change on first file" {
    run -1 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'ABORT'
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "abort message when no change on second file" {
    run -1 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'ABORT'
    assertFile1Changed
    assertFile2Unchanged
}

@test "no abort message when first file processing fails" {
    run -123 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${failFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Changed
}

@test "no abort message when second file processing fails" {
    run -123 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${failSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Changed
    assertFile2Unchanged
}

@test "no abort message when all file processing fails" {
    run -123 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${failAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "no abort message when processing fails with 255" {
    run -124 processEachFile --message-on-abort ABORT --abort-unless-change --exec "${fail255Command[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "abort message with embedded file when no change on processing two files" {
    run -1 processEachFile --message-on-abort 'ABORT for %q' --abort-unless-change --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output "ABORT for $FILE1"
    assertFile1Unchanged
    assertFile2Unchanged
}
