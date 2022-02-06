#!/usr/bin/env bats

load fixture

@test "no diff when file is unchanged" {
    run processEachFile --diff --exec "${changeNoneCommand[@]}" \; "$FILE1"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}
