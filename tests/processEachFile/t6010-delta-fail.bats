#!/usr/bin/env bats

load fixture

@test "failing delta command aborts processing with exit status 3" {
    run processEachFile --delta-via false --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 3 ]
    [ "$output" = "" ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "non-existing delta command aborts processing with exit status 3" {
    LC_ALL=C run processEachFile --delta-via doesNotExist --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 3 ]
    [[ "$output" =~ 'doesNotExist: command not found' ]]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "succeeding delta command that does not return anything aborts processing with error message and exit status 3" {
    run processEachFile --delta-via true --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 3 ]
    [ "$output" = "ERROR: Empty digest from true." ]
    assertFile1Unchanged
    assertFile2Unchanged
}
