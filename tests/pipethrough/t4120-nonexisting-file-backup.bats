#!/usr/bin/env bats

load nofile

@test "N does not create a backup when file does not exist" {
    backupFile="${NOFILE}.bak"; rm -f -- "$backupFile"
    run -0 pipethrough --backup .bak --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$backupFile"
    assert_exists "$NOFILE"
}

@test "1 does not create a backup when file does not exist" {
    backupFile="${NOFILE}.bak"; rm -f -- "$backupFile"
    run -0 pipethrough1 --backup .bak "${createFileCommand[@]}" "$NOFILE"
    assert_output ''
    assert_not_exists "$backupFile"
    assert_exists "$NOFILE"
}
