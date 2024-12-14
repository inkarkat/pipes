#!/usr/bin/env bats

load fixture

@test "create an original backup without changing the file" {
    type -t writeorig >/dev/null || skip 'writeorig is not available'

    backupFile1="${FILE1}.orig"; rm -f -- "$backupFile1"
    run processEachFile --backup-command writeorig --exec "${changeNoneCommand[@]}" \; "$FILE1"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Unchanged "$backupFile1"
    assertFile1Unchanged
}

@test "create original backups before changing the files" {
    type -t writeorig >/dev/null || skip 'writeorig is not available'

    backupFile1="${FILE1}.orig"; rm -f -- "$backupFile1"
    backupFile2="${FILE2}.orig"; rm -f -- "$backupFile2"
    run processEachFile --backup-command writeorig --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Unchanged "$backupFile1"
    assertFile1Changed
    assertFile2Unchanged "$backupFile2"
    assertFile2Changed
}
