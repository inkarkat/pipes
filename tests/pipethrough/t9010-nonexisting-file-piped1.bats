#!/usr/bin/env bats

load nofile

@test "1 successfully turning non-existing file into empty file" {
    run -0 pipethrough1 --piped "${noopCommand[@]}" "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
    assert_size_zero "$NOFILE"
}

@test "1 successfully creating non-existing file" {
    run -0 pipethrough1 --piped "${createFileCommand[@]}" "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "1 successfully truncating existing file" {
    run -0 pipethrough1 --piped "${truncateFileCommand[@]}" "$FILE"
    assert_output ''
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}

@test "1 message when turning non-existing file into empty file" {
    run -0 pipethrough1 --piped --message-subject SUBJECT "${noopCommand[@]}" "$NOFILE"
    assert_output "Successfully performed SUBJECT on $NOFILE without changing it"
    assert_exists "$NOFILE"
    assert_size_zero "$NOFILE"
}

@test "1 message when creating non-existing file" {
    run -0 pipethrough1 --piped --message-subject SUBJECT "${createFileCommand[@]}" "$NOFILE"
    assert_output "SUBJECT changed $NOFILE"
    assert_exists "$NOFILE"
}

@test "1 message when truncating existing file" {
    run -0 pipethrough1 --piped --message-subject SUBJECT "${truncateFileCommand[@]}" "$FILE"
    assert_output "SUBJECT changed $FILE"
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}

@test "1 erroring when ignoring non-existing file" {
    run -1 pipethrough1 --piped --error-unless-change "${noopCommand[@]}" "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "1 not erroring when turning non-existing file into empty file" {
    run -0 pipethrough1 --piped --error-on-change "${noopCommand[@]}" "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
    assert_size_zero "$NOFILE"
}

@test "1 erroring when creating non-existing file" {
    run -1 pipethrough1 --piped --error-on-change "${createFileCommand[@]}" "$NOFILE"
    assert_output ''
    assert_not_exists "$NOFILE"
}

@test "1 not erroring when creating non-existing file" {
    run -0 pipethrough1 --piped --error-unless-change "${createFileCommand[@]}" "$NOFILE"
    assert_output ''
    assert_exists "$NOFILE"
}

@test "1 erroring when truncating existing file" {
    run -1 pipethrough1 --piped --error-on-change "${truncateFileCommand[@]}" "$FILE"
    assert_output ''
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}

@test "1 not erroring when truncating existing file" {
    run -0 pipethrough1 --piped --error-unless-change "${truncateFileCommand[@]}" "$FILE"
    assert_output ''
    assert_exists "$FILE"
    assert_size_zero "$FILE"
}
