#!/bin/bash

load fixture
bats_load_library bats-file

appendToFile()
{
    local filespec="${1:?}"; shift
    printf '%s\n' "$*" >> "$filespec"
}
export -f appendToFile

readonly NOFILE="${BATS_TMPDIR}/NOFILE"; rm --force -- "$NOFILE"
readonly FILE="${BATS_TMPDIR}/FILE"; echo "FOO" > "$FILE"
typeset -gra createFileCommand=(appendToFile {} FOO)
typeset -gra deleteFileCommand=(rm --)
typeset -gra noopCommand=(:)
