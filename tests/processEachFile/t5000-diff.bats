#!/usr/bin/env bats

load fixture

@test "no diff when file is unchanged" {
    run -0 processEachFile --diff --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
}

@test "show diff when first file is changed" {
    run -0 processEachFile --diff --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_line -n -3 "@@ -1 +1 @@"
    assert_line -n -2 "-FOO"
    assert_line -n -1 "+Fi"
}

@test "show diff when both files are changed" {
    run -0 processEachFile --diff --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_line -n -8 "@@ -1 +1 @@"
    assert_line -n -7 "-FOO"
    assert_line -n -6 "+Fi"
    assert_line -n -3 "@@ -1 +1 @@"
    assert_line -n -2 "-fox"
    assert_line -n -1 "+fix"
}

@test "show messages and diff when first file is changed" {
    run -0 processEachFile --message-subject SUBJECT --diff --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_line -n -5 "@@ -1 +1 @@"
    assert_line -n -4 "-FOO"
    assert_line -n -3 "+Fi"
    assert_line -n -2 "SUBJECT changed $FILE1"
    assert_line -n -1 "Successfully performed SUBJECT on $FILE2 without changing it"
}
