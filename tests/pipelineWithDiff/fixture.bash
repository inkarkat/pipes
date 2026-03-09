#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

typeset -gra CHANGE_COMMAND=(sed -e 's/O\+/i/')
typeset -gra DUPLICATE_COMMAND=(sed -e 's/.*/&&/g')
typeset -gra BRACE_COMMAND=(sed -e 's/.*/[&]/g')
typeset -gra FAIL_COMMAND=(sed -e 'q 1')
typeset -gra MODIFY_AND_FAIL_COMMAND=(sed -e 's/O\+/i/g' -e 'q 42')
typeset -gra NOOP_COMMAND=(cat)
readonly OUTPUT_FILE="${BATS_TMPDIR}/out.txt"

fixtureSetup()
{
    echo 'EXISTING CONTENTS' > "$OUTPUT_FILE"
}
setup()
{
    fixtureSetup
}
