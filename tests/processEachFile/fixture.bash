#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

readonly FILE1="${BATS_TMPDIR}/FILE1"
readonly FILE2="${BATS_TMPDIR}/FILE2"
typeset -gra changeAllCommand=(sed -i -e 's/[oO]\+/i/g')
typeset -gra changeFirstCommand=(sed -i -e 's/O\+/i/g')
typeset -gra changeSecondCommand=(sed -i -e 's/o/i/g')
typeset -gra changeNoneCommand=(sed -i -e 's/y/*/g')
typeset -gra failAllCommand=(sed -i -e '/[oO]/q 1')
typeset -gra failFirstCommand=(sed -i -e 's/o/i/g' -e '/O/q 1')
typeset -gra failSecondCommand=(sed -i -e 's/O\+/i/g' -e '/o/q 1')
typeset -gra fail255Command=(sed -i -e 'q 255')

setup()
{
    echo "FOO" > "$FILE1"
    echo "fox" > "$FILE2"
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
