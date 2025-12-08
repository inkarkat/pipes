#!/usr/bin/env bats

load fixture

@test "failing backup command aborts processing with exit status 3" {
    run -3 processEachFile --backup-command false --exec "${changeAllCommand[@]}" \; "$FILE1"
    assert_output ''
    assert_FILE1_unchanged
}
