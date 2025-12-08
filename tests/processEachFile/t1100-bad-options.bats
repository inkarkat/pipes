#!/usr/bin/env bats

load fixture

@test "no files passed with --command exits with 99" {
    run -99 processEachFile --command cat
    assert_output ''
}

@test "no files passed with -- exits with 99" {
    run -99 processEachFile -- true --
    assert_output ''
}
