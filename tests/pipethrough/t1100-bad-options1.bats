#!/usr/bin/env bats

load fixture

@test "no files passed exit with usage help and status 2" {
    run -2 pipethrough1 --command cat
    assert_line -n 0 -e "^Usage:"
}

@test "no files passed after -- exit with usage help and status 2" {
    run -2 pipethrough1 --command cat --
    assert_line -n 0 -e "^Usage:"
}
