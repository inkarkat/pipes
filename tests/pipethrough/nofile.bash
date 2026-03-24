#!/bin/bash

load fixture
bats_load_library bats-file

readonly NOFILE="${BATS_TMPDIR}/NOFILE"; rm --force -- "$NOFILE"
readonly FILE="${BATS_TMPDIR}/FILE"; echo "FOO" > "$FILE"
typeset -gra createFileCommand=(echo FOO)
typeset -gra truncateFileCommand=(printf '')
typeset -gra noopCommand=(:)
