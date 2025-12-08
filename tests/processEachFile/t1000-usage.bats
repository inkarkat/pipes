#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 processEachFile
    assert_line -n 0 "ERROR: No COMMAND(s) specified; need to pass -c|--command \"COMMANDLINE\", or --exec SIMPLECOMMAND [...] ; or SIMPLECOMMAND."
    assert_line -n 1 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
    run -2 processEachFile --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "empty SIMPLECOMMAND prints message and usage instructions" {
    run -2 processEachFile -- --
    assert_line -n 0 "ERROR: No COMMAND(s) specified; need to pass -c|--command \"COMMANDLINE\", or --exec SIMPLECOMMAND [...] ; or SIMPLECOMMAND."
    assert_line -n 1 -e '^Usage:'
}

@test "SIMPLECOMMAND without -- prints message and usage instructions" {
    run -2 processEachFile -- true
    assert_line -n 0 'ERROR: -- SIMPLECOMMAND [ARGUMENTS ...] must be concluded with --!'
    assert_line -n 1 -e '^Usage:'
}

@test "--exec without ; prints message and usage instructions" {
    run -2 processEachFile --exec true
    assert_line -n 0 "ERROR: --exec command must be concluded with ';'"
    assert_line -n 1 -e '^Usage:'
}

@test "both --abort-unless-change and --abort-on-change prints message and usage instructions" {
    run -2 processEachFile --abort-unless-change --abort-on-change -- true -- /dev/null
    assert_line -n 0 'ERROR: Cannot specify both --abort-unless-change and --abort-on-change at once!'
    assert_line -n 1 -e '^Usage:'
}

@test "--warn-unless-change prints message and usage instructions" {
    run -2 processEachFile --message-subject SUBJECT --message-on-change "" --warn-unless-change -- true -- /dev/null
    assert_line -n 0 "ERROR: --warn-unless-change cannot be specified when change checking isn't enabled"
    assert_line -n 1 -e '^Usage:'
}
