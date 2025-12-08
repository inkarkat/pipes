#!/bin/bash

load fixture
bats_load_library bats-file

nofileSetup()
{
    readonly NOFILE="${BATS_TMPDIR}/NOFILE"; rm --force -- "$NOFILE"
    readonly FILE="${BATS_TMPDIR}/FILE"; echo "FOO" > "$FILE"
    createFileCommand=(echo FOO)
    truncateFileCommand=(printf '')
    noopCommand=(:)
}
setup()
{
    nofileSetup
}
