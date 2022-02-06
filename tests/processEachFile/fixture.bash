#!/bin/bash

setup()
{
    readonly FILE1="${BATS_TMPDIR}/FILE1"; echo "FOO" > "$FILE1"
    readonly FILE2="${BATS_TMPDIR}/FILE2"; echo "fox" > "$FILE2"
    changeAllCommand=(sed -i -e 's/[oO]/i/g')
    changeFirstCommand=(sed -i -e 's/O/i/g')
    changeSecondCommand=(sed -i -e 's/o/i/g')
    changeNoneCommand=(sed -i -e 's/y/*/g')
    failAllCommand=(sed -i -e '/[oO]/q 1')
    failFirstCommand=(sed -i -e 's/o/i/g' -e '/O/q 1')
    failSecondCommand=(sed -i -e 's/O/i/g' -e '/o/q 1')
    fail255Command=(sed -i -e 'q 255')
}

assertFile1Unchanged()
{
    [ "$(< "$FILE1")" = 'FOO' ]
}
assertFile2Unchanged()
{
    [ "$(< "$FILE2")" = 'fox' ]
}
assertFile1Changed()
{
    [ "$(< "$FILE1")" = 'Fii' ]
}
assertFile2Changed()
{
    [ "$(< "$FILE2")" = 'fix' ]
}
