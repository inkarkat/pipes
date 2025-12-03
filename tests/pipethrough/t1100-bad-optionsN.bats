#!/usr/bin/env bats

@test "no files passed exits with 99" {
    run pipethrough --command cat
    [ $status -eq 99 ]
    [ "$output" = "" ]
}

@test "no files passed after -- exits with 99" {
    run pipethrough --command cat --
    [ $status -eq 99 ]
    [ "$output" = "" ]
}
