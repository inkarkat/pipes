#!/usr/bin/env bats

load nofile

@test "N successfully turning non-existing file into empty file" {
    run -0 pipethrough --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
    assert_size_zero "$NOFILE"
}

@test "N successfully creating non-existing file" {
    run -0 pipethrough --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "N successfully truncating existing file" {
    run -0 pipethrough --exec "${truncateFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}

@test "N message when turning non-existing file into empty file" {
    run -0 pipethrough --message-subject SUBJECT --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output "Successfully performed SUBJECT on $NOFILE without changing it"
    assert_exists "$NOFILE"
    assert_size_zero "$NOFILE"
}

@test "N message when creating non-existing file" {
    run -0 pipethrough --message-subject SUBJECT --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output "SUBJECT changed $NOFILE"
    assert_exists "$NOFILE"
}

@test "N message when truncating existing file" {
    run -0 pipethrough --message-subject SUBJECT --exec "${truncateFileCommand[@]}" \; "$FILE"
    assert_output "SUBJECT changed $FILE"
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}

@test "N aborting when ignoring non-existing file" {
    run -1 pipethrough --abort-unless-change --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "N not aborting when turning non-existing file into empty file" {
    run -0 pipethrough --abort-on-change --exec "${noopCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
    assert_size_zero "$NOFILE"
}

@test "N aborting when creating non-existing file" {
    run -1 pipethrough --abort-on-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "N not aborting when creating non-existing file" {
    run -0 pipethrough --abort-unless-change --exec "${createFileCommand[@]}" \; "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "N aborting when truncating existing file" {
    run -1 pipethrough --abort-on-change --exec "${truncateFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}

@test "N not aborting when truncating existing file" {
    run -0 pipethrough --abort-unless-change --exec "${truncateFileCommand[@]}" \; "$FILE"
    assert_output ''
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}
