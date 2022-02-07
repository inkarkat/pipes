#!/usr/bin/env bats

load nofile

@test "N does not create a backup when file does not exist" {
    backupFile="${NOFILE}.bak"; rm -f -- "$backupFile"
    run pipethrough --backup .bak --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$backupFile" ]
    [ -e "$NOFILE" ]
}

@test "1 does not create a backup when file does not exist" {
    backupFile="${NOFILE}.bak"; rm -f -- "$backupFile"
    run pipethrough1 --backup .bak "${createFileCommand[@]}" "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$backupFile" ]
    [ -e "$NOFILE" ]
}
