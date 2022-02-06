#!/usr/bin/env bats

load fixture

@test "failing backup command aborts processing with exit status 3" {
    run processEachFile --backup-command false --exec "${changeAllCommand[@]}" \; "$FILE1"
    [ $status -eq 3 ]
    [ "$output" = "" ]
    assertFile1Unchanged
}
