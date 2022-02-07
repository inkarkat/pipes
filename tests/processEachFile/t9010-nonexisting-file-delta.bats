#!/usr/bin/env bats

load nofile

setup()
{
    exists cksum || skip
    nofileSetup
}

@test "delta successfully ignoring non-existing file" {
    run processEachFile --delta-via cksum --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "delta successfully creating non-existing file" {
    run processEachFile --delta-via cksum --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "delta successfully deleting existing file" {
    run processEachFile --delta-via cksum --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$FILE" ]
}

@test "delta message when ignoring non-existing file" {
    run processEachFile --delta-via cksum --message-subject SUBJECT --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $NOFILE without changing it" ]
    [ ! -e "$NOFILE" ]
}

@test "delta message when creating non-existing file" {
    run processEachFile --delta-via cksum --message-subject SUBJECT --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $NOFILE" ]
    [ -e "$NOFILE" ]
}

@test "delta message when deleting existing file" {
    run processEachFile --delta-via cksum --message-subject SUBJECT --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $FILE" ]
    [ ! -e "$FILE" ]
}

@test "delta aborting when ignoring non-existing file" {
    run processEachFile --delta-via cksum --abort-unless-change --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "delta not aborting when ignoring non-existing file" {
    run processEachFile --delta-via cksum --abort-on-change --exec "${noopCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NOFILE" ]
}

@test "delta aborting when creating non-existing file" {
    run processEachFile --delta-via cksum --abort-on-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "delta not aborting when creating non-existing file" {
    run processEachFile --delta-via cksum --abort-unless-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NOFILE" ]
}

@test "delta aborting when deleting existing file" {
    run processEachFile --delta-via cksum --abort-on-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ ! -e "$FILE" ]
}

@test "delta not aborting when deleting existing file" {
    run processEachFile --delta-via cksum --abort-unless-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$FILE" ]
}
