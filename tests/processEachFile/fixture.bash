#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

setup()
{
    readonly FILE1="${BATS_TMPDIR}/FILE1"; echo "FOO" > "$FILE1"
    readonly FILE2="${BATS_TMPDIR}/FILE2"; echo "fox" > "$FILE2"
    changeAllCommand=(sed -i -e 's/[oO]\+/i/g')
    changeFirstCommand=(sed -i -e 's/O\+/i/g')
    changeSecondCommand=(sed -i -e 's/o/i/g')
    changeNoneCommand=(sed -i -e 's/y/*/g')
    failAllCommand=(sed -i -e '/[oO]/q 1')
    failFirstCommand=(sed -i -e 's/o/i/g' -e '/O/q 1')
    failSecondCommand=(sed -i -e 's/O\+/i/g' -e '/o/q 1')
    fail255Command=(sed -i -e 'q 255')
}

assert_FILE1_unchanged()
{
    [ "$(< "${1:-$FILE1}")" = 'FOO' ]
}
assert_FILE2_unchanged()
{
    [ "$(< "${1:-$FILE2}")" = 'fox' ]
}
assert_FILE1_changed()
{
    [ "$(< "${1:-$FILE1}")" = 'Fi' ]
}
assert_FILE2_changed()
{
    [ "$(< "${1:-$FILE2}")" = 'fix' ]
}
