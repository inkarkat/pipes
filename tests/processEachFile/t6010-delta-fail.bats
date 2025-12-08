#!/usr/bin/env bats

load fixture

@test "failing delta command aborts processing with exit status 3" {
    run -3 processEachFile --delta-via false --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "non-existing delta command aborts processing with exit status 3" {
    LC_ALL=C run -3 processEachFile --delta-via doesNotExist --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output -e 'doesNotExist: command not found'
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}

@test "succeeding delta command that does not return anything aborts processing with error message and exit status 3" {
    run -3 processEachFile --delta-via true --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'ERROR: Empty digest from true.'
    assert_FILE1_unchanged
    assert_FILE2_unchanged
}
