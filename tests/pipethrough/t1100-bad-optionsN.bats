#!/usr/bin/env bats

load fixture

@test "no files passed exits with 99" {
    run -99 pipethrough --command cat
    assert_output ''
}

@test "no files passed after -- exits with 99" {
    run -99 pipethrough --command cat --
    assert_output ''
}
