#!/usr/bin/env bats

load nofile

@test "does not create a backup when file does not exist" {
    backupFile="${NOFILE}.bak"; rm -f -- "$backupFile"
    run processEachFile --backup .bak --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$backupFile" ]
    [ -e "$NOFILE" ]
}
