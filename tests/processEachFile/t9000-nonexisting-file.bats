#!/usr/bin/env bats

load nofile

@test "successfully ignoring non-existing file" {
    run processEachFile --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "successfully creating non-existing file" {
    run processEachFile --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "successfully deleting existing file" {
    run processEachFile --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$FILE" ]
}

@test "message when ignoring non-existing file" {
    run processEachFile --message-subject SUBJECT --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $NOFILE without changing it" ]
    [ ! -e "$NOFILE" ]
}

@test "message when creating non-existing file" {
    run processEachFile --message-subject SUBJECT --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $NOFILE" ]
    [ -e "$NOFILE" ]
}

@test "message when deleting existing file" {
    run processEachFile --message-subject SUBJECT --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $FILE" ]
    [ ! -e "$FILE" ]
}

@test "aborting when ignoring non-existing file" {
    run processEachFile --abort-unless-change --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "not aborting when ignoring non-existing file" {
    run processEachFile --abort-on-change --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "aborting when creating non-existing file" {
    run processEachFile --abort-on-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "not aborting when creating non-existing file" {
    run processEachFile --abort-unless-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "aborting when deleting existing file" {
    run processEachFile --abort-on-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$FILE" ]
}

@test "not aborting when deleting existing file" {
    run processEachFile --abort-unless-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$FILE" ]
}
