#!/usr/bin/env bats

load fixture

@test "show diff from backup when first file is changed" {
    backupFile1="${FILE1}.bak"; rm -f -- "$backupFile1"
    run processEachFile --backup .bak --diff --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    [ $status -eq 0 ]
    [[ "${lines[-5]}" =~ ^"--- $backupFile1" ]]
    [[ "${lines[-4]}" =~ ^"+++ $FILE1" ]]
    [ "${lines[-3]}" = "@@ -1 +1 @@" ]
    [ "${lines[-2]}" = "-FOO" ]
    [ "${lines[-1]}" = "+Fii" ]
}
