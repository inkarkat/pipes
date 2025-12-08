#!/usr/bin/env bats

load fixture

@test "create a backup without changing the file" {
    backupFile1="${FILE1}.bak"; rm -f -- "$backupFile1"
    run -0 processEachFile --backup .bak --exec "${changeNoneCommand[@]}" \; "$FILE1"
    assert_output ''
    assert_FILE1_unchanged "$backupFile1"
    assert_FILE1_unchanged
}

@test "create backups before changing the files" {
    backupFile1="${FILE1}.bak"; rm -f -- "$backupFile1"
    backupFile2="${FILE2}.bak"; rm -f -- "$backupFile2"
    run -0 processEachFile --backup .bak --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged "$backupFile1"
    assert_FILE1_changed
    assert_FILE2_unchanged "$backupFile2"
    assert_FILE2_changed
}
