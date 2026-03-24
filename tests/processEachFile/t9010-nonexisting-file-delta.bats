#!/usr/bin/env bats

load nofile

setup()
{
    exists cksum || skip 'cksum is not available'
}

@test "delta successfully ignoring non-existing file" {
    run -0 processEachFile --delta-via cksum --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "delta successfully creating non-existing file" {
    run -0 processEachFile --delta-via cksum --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "delta successfully deleting existing file" {
    run -0 processEachFile --delta-via cksum --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_not_exists "$FILE"
}

@test "delta message when ignoring non-existing file" {
    run -0 processEachFile --delta-via cksum --message-subject SUBJECT --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output "Successfully performed SUBJECT on $NOFILE without changing it"
    assert_not_exists "$NOFILE"
}

@test "delta message when creating non-existing file" {
    run -0 processEachFile --delta-via cksum --message-subject SUBJECT --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output "SUBJECT changed $NOFILE"
    assert_exists "$NOFILE"
}

@test "delta message when deleting existing file" {
    run -0 processEachFile --delta-via cksum --message-subject SUBJECT --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output "SUBJECT changed $FILE"
    assert_not_exists "$FILE"
}

@test "delta aborting when ignoring non-existing file" {
    run -1 processEachFile --delta-via cksum --abort-unless-change --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "delta not aborting when ignoring non-existing file" {
    run -0 processEachFile --delta-via cksum --abort-on-change --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "delta aborting when creating non-existing file" {
    run -1 processEachFile --delta-via cksum --abort-on-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "delta not aborting when creating non-existing file" {
    run -0 processEachFile --delta-via cksum --abort-unless-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "delta aborting when deleting existing file" {
    run -1 processEachFile --delta-via cksum --abort-on-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_not_exists "$FILE"
}

@test "delta not aborting when deleting existing file" {
    run -0 processEachFile --delta-via cksum --abort-unless-change --exec "${deleteFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_not_exists "$FILE"
}
