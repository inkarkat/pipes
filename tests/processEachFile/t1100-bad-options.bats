#!/usr/bin/env bats

@test "no files passed with --command exits with 99" {
    run processEachFile --command cat
    [ $status -eq 99 ]
    [ "$output" = "" ]
}

@test "no files passed with -- exits with 99" {
    run processEachFile -- true --
    [ $status -eq 99 ]
    [ "$output" = "" ]
}
