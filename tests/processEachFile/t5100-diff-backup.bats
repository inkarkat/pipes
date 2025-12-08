#!/usr/bin/env bats

load fixture

@test "show diff from backup when first file is changed" {
    backupFile1="${FILE1}.bak"; rm -f -- "$backupFile1"
    run -0 processEachFile --backup .bak --diff --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_line -n -5 -e ^"--- $backupFile1"
    assert_line -n -4 -e ^"\+\+\+ $FILE1"
    assert_line -n -3 "@@ -1 +1 @@"
    assert_line -n -2 "-FOO"
    assert_line -n -1 "+Fi"
}
