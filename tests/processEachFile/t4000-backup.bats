#!/usr/bin/env bats

load fixture

@test "create a backup without changing the file" {
    backupFile1="${FILE1}.bak"; rm -f -- "$backupFile1"
    run processEachFile --backup .bak --exec "${changeNoneCommand[@]}" \; "$FILE1"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Unchanged "$backupFile1"
    assertFile1Unchanged
}

@test "create backups before changing the files" {
    backupFile1="${FILE1}.bak"; rm -f -- "$backupFile1"
    backupFile2="${FILE2}.bak"; rm -f -- "$backupFile2"
    run processEachFile --backup .bak --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assertFile1Unchanged "$backupFile1"
    assertFile1Changed
    assertFile2Unchanged "$backupFile2"
    assertFile2Changed
}
