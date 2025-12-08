#!/usr/bin/env bats

load fixture

@test "create an original backup without changing the file" {
    type -t writeorig >/dev/null || skip 'writeorig is not available'

    backupFile1="${FILE1}.orig"; rm -f -- "$backupFile1"
    run -0 processEachFile --backup-command writeorig --exec "${changeNoneCommand[@]}" \; "$FILE1"
    assert_output ''
    assert_FILE1_unchanged "$backupFile1"
    assert_FILE1_unchanged
}

@test "create original backups before changing the files" {
    type -t writeorig >/dev/null || skip 'writeorig is not available'

    backupFile1="${FILE1}.orig"; rm -f -- "$backupFile1"
    backupFile2="${FILE2}.orig"; rm -f -- "$backupFile2"
    run -0 processEachFile --backup-command writeorig --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged "$backupFile1"
    assert_FILE1_changed
    assert_FILE2_unchanged "$backupFile2"
    assert_FILE2_changed
}
