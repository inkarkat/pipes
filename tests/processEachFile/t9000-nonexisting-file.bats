#!/usr/bin/env bats

load nofile

@test "successfully ignoring non-existing file" {
    run -0 processEachFile --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "successfully creating non-existing file" {
    run -0 processEachFile --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "successfully deleting existing file" {
    run -0 processEachFile --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_not_exists "$FILE"
}

@test "message when ignoring non-existing file" {
    run -0 processEachFile --message-subject SUBJECT --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output "Successfully performed SUBJECT on $NOFILE without changing it"
    assert_not_exists "$NOFILE"
}

@test "message when creating non-existing file" {
    run -0 processEachFile --message-subject SUBJECT --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output "SUBJECT changed $NOFILE"
    assert_exists "$NOFILE"
}

@test "message when deleting existing file" {
    run -0 processEachFile --message-subject SUBJECT --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output "SUBJECT changed $FILE"
    assert_not_exists "$FILE"
}

@test "aborting when ignoring non-existing file" {
    run -1 processEachFile --abort-unless-change --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "not aborting when ignoring non-existing file" {
    run -0 processEachFile --abort-on-change --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "aborting when creating non-existing file" {
    run -1 processEachFile --abort-on-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "not aborting when creating non-existing file" {
    run -0 processEachFile --abort-unless-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "aborting when deleting existing file" {
    run -1 processEachFile --abort-on-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_not_exists "$FILE"
}

@test "not aborting when deleting existing file" {
    run -0 processEachFile --abort-unless-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_not_exists "$FILE"
}
