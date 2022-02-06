#!/usr/bin/env bats

load fixture

@test "usage error when trying delta via backup without backup" {
    run processEachFile --delta-via backup --message-subject SUBJECT --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Cannot use --delta-via backup without enabling backups." ]
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "explicitly specifying default delta via copy give change messages for subject" {
    run processEachFile --delta-via copy --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $FILE1 without changing it
SUBJECT changed $FILE2" ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "delta via file age give change messages for both files even though the contents of the first did not change" {
    exists fileAge || skip

    sleep 1 # So that the file age of a freshly created test file will be different.
    run processEachFile --delta-via fileAge --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $FILE1
SUBJECT changed $FILE2" ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "delta via file size gives change message for the first file only because the size of the second file is not changed" {
    exists fileSize || skip

    run processEachFile --delta-via fileSize --message-subject SUBJECT --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "SUBJECT changed $FILE1
Successfully performed SUBJECT on $FILE2 without changing it" ]
    assertFile1Changed
    assertFile2Changed
}

@test "delta via cksum give change messages for the second file" {
    exists cksum || skip

    run processEachFile --delta-via cksum --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $FILE1 without changing it
SUBJECT changed $FILE2" ]
    assertFile1Unchanged
    assertFile2Changed
}

@test "delta via sha256sum give change messages for the second file" {
    exists sha256sum || skip

    run processEachFile --delta-via sha256sum --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "Successfully performed SUBJECT on $FILE1 without changing it
SUBJECT changed $FILE2" ]
    assertFile1Unchanged
    assertFile2Changed
}
