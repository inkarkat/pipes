#!/usr/bin/env bats

@test "no files passed exit with usage help and status 2" {
    run pipethrough1 --command cat
    [ $status -eq 2 ]
    [ "${lines[0]%% *}" = "Usage:" ]
}
