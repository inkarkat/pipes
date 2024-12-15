#!/usr/bin/env bats

@test "no arguments prints message and usage instructions" {
    run processEachFile
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No COMMAND(s) specified; need to pass -c|--command \"COMMANDLINE\", or --exec SIMPLECOMMAND [...] ; or SIMPLECOMMAND." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
    run processEachFile --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "empty SIMPLECOMMAND prints message and usage instructions" {
    run processEachFile -- --
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No COMMAND(s) specified; need to pass -c|--command \"COMMANDLINE\", or --exec SIMPLECOMMAND [...] ; or SIMPLECOMMAND." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "SIMPLECOMMAND without -- prints message and usage instructions" {
    run processEachFile -- true
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: -- SIMPLECOMMAND [ARGUMENTS ...] must be concluded with --!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "--exec without ; prints message and usage instructions" {
    run processEachFile --exec true
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: --exec command must be concluded with ';'" ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "both --abort-unless-change and --abort-on-change prints message and usage instructions" {
    run processEachFile --abort-unless-change --abort-on-change -- true -- /dev/null
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Cannot specify both --abort-unless-change and --abort-on-change at once!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "--warn-unless-change prints message and usage instructions" {
    run processEachFile --message-subject SUBJECT --message-on-change "" --warn-unless-change -- true -- /dev/null
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: --warn-unless-change cannot be specified when change checking isn't enabled" ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}
