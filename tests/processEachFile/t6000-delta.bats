#!/usr/bin/env bats

load fixture

@test "usage error when trying delta via backup without backup" {
    run -2 processEachFile --delta-via backup --message-subject SUBJECT --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output 'ERROR: Cannot use --delta-via backup without enabling backups.'
    assertFile1Unchanged
    assertFile2Unchanged
}

@test "explicitly specifying default delta via copy give change messages for subject" {
    run -0 processEachFile --delta-via copy --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Successfully performed SUBJECT on $FILE1 without changing it
SUBJECT changed $FILE2
EOF
    assertFile1Unchanged
    assertFile2Changed
}

@test "delta via file age give change messages for both files even though the contents of the first did not change" {
    exists fileAge || skip 'fileAge is not available'

    sleep 1 # So that the file age of a freshly created test file will be different.
    run -0 processEachFile --delta-via fileAge --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
SUBJECT changed $FILE2
EOF
    assertFile1Unchanged
    assertFile2Changed
}

@test "delta via file size gives change message for the first file only because the size of the second file is not changed" {
    exists fileSize || skip 'fileSize is not available'

    run -0 processEachFile --delta-via fileSize --message-subject SUBJECT --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
SUBJECT changed $FILE1
Successfully performed SUBJECT on $FILE2 without changing it
EOF
    assertFile1Changed
    assertFile2Changed
}

@test "delta via cksum give change messages for the second file" {
    exists cksum || skip 'cksum is not available'

    run -0 processEachFile --delta-via cksum --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Successfully performed SUBJECT on $FILE1 without changing it
SUBJECT changed $FILE2
EOF
    assertFile1Unchanged
    assertFile2Changed
}

@test "delta via sha256sum give change messages for the second file" {
    exists sha256sum || skip 'sha256sum is not available'

    run -0 processEachFile --delta-via sha256sum --message-subject SUBJECT --exec "${changeSecondCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
Successfully performed SUBJECT on $FILE1 without changing it
SUBJECT changed $FILE2
EOF
    assertFile1Unchanged
    assertFile2Changed
}
