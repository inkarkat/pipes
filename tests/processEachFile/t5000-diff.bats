#!/usr/bin/env bats

load fixture

@test "no diff when file is unchanged" {
    run processEachFile --diff --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "show diff when first file is changed" {
    run processEachFile --diff --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "${lines[-3]}" = "@@ -1 +1 @@" ]
    [ "${lines[-2]}" = "-FOO" ]
    [ "${lines[-1]}" = "+Fii" ]
}

@test "show diff when both files are changed" {
    run processEachFile --diff --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "${lines[-8]}" = "@@ -1 +1 @@" ]
    [ "${lines[-7]}" = "-FOO" ]
    [ "${lines[-6]}" = "+Fii" ]
    [ "${lines[-3]}" = "@@ -1 +1 @@" ]
    [ "${lines[-2]}" = "-fox" ]
    [ "${lines[-1]}" = "+fix" ]
}

@test "show messages and diff when first file is changed" {
    run processEachFile --message-subject SUBJECT --diff --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [ "${lines[-5]}" = "@@ -1 +1 @@" ]
    [ "${lines[-4]}" = "-FOO" ]
    [ "${lines[-3]}" = "+Fii" ]
    [ "${lines[-2]}" = "SUBJECT changed $FILE1" ]
    [ "${lines[-1]}" = "Successfully performed SUBJECT on $FILE2 without changing it" ]
}
