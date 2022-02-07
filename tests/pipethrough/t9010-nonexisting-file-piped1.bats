#!/usr/bin/env bats

load nofile

@test "1 successfully turning non-existing file into empty file" {
    run pipethrough1 --piped "${noopCommand[@]}" "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
    [ ! -s "$NOFILE" ]
}

@test "1 successfully creating non-existing file" {
    run pipethrough1 --piped "${createFileCommand[@]}" "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "1 successfully truncating existing file" {
    run pipethrough1 --piped "${truncateFileCommand[@]}" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}

@test "1 message when turning non-existing file into empty file" {
    run pipethrough1 --piped --message-subject SUBJECT "${noopCommand[@]}" "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $NOFILE without changing it" ]
    [ -e "$NOFILE" ]
    [ ! -s "$NOFILE" ]
}

@test "1 message when creating non-existing file" {
    run pipethrough1 --piped --message-subject SUBJECT "${createFileCommand[@]}" "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $NOFILE" ]
    [ -e "$NOFILE" ]
}

@test "1 message when truncating existing file" {
    run pipethrough1 --piped --message-subject SUBJECT "${truncateFileCommand[@]}" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $FILE" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}

@test "1 erroring when ignoring non-existing file" {
    run pipethrough1 --piped --error-unless-change "${noopCommand[@]}" "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "1 not erroring when turning non-existing file into empty file" {
    run pipethrough1 --piped --error-on-change "${noopCommand[@]}" "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
    [ ! -s "$NOFILE" ]
}

@test "1 erroring when creating non-existing file" {
    run pipethrough1 --piped --error-on-change "${createFileCommand[@]}" "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "1 not erroring when creating non-existing file" {
    run pipethrough1 --piped --error-unless-change "${createFileCommand[@]}" "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "1 erroring when truncating existing file" {
    run pipethrough1 --piped --error-on-change "${truncateFileCommand[@]}" "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}

@test "1 not erroring when truncating existing file" {
    run pipethrough1 --piped --error-unless-change "${truncateFileCommand[@]}" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$FILE" ]
    [ ! -s "$FILE" ]
}
