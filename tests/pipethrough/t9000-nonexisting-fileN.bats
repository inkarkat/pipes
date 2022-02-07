#!/usr/bin/env bats

load nofile

@test "N successfully turning non-existing file into empty file" {
    run pipethrough --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
    [ ! -s "$NOFILE" ]
}

@test "N successfully creating non-existing file" {
    run pipethrough --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "N successfully truncating existing file" {
    run pipethrough --exec "${truncateFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}

@test "N message when turning non-existing file into empty file" {
    run pipethrough --message-subject SUBJECT --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $NOFILE without changing it" ]
    [ -e "$NOFILE" ]
    [ ! -s "$NOFILE" ]
}

@test "N message when creating non-existing file" {
    run pipethrough --message-subject SUBJECT --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $NOFILE" ]
    [ -e "$NOFILE" ]
}

@test "N message when truncating existing file" {
    run pipethrough --message-subject SUBJECT --exec "${truncateFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $FILE" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}

@test "N aborting when ignoring non-existing file" {
    run pipethrough --abort-unless-change --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "N not aborting when turning non-existing file into empty file" {
    run pipethrough --abort-on-change --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
    [ ! -s "$NOFILE" ]
}

@test "N aborting when creating non-existing file" {
    run pipethrough --abort-on-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "N not aborting when creating non-existing file" {
    run pipethrough --abort-unless-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "N aborting when truncating existing file" {
    run pipethrough --abort-on-change --exec "${truncateFileCommand[@]}" \; "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}

@test "N not aborting when truncating existing file" {
    run pipethrough --abort-unless-change --exec "${truncateFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}
