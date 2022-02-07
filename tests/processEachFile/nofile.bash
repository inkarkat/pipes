#!/bin/bash

nofileSetup()
{
    readonly NOFILE="${BATS_TMPDIR}/NOFILE"; rm --force -- "$NOFILE"
    readonly FILE="${BATS_TMPDIR}/FILE"; echo "FOO" > "$FILE"
    createFileCommand=(appendToFile {} FOO)
    deleteFileCommand=(rm --)
    noopCommand=(:)
}
setup()
{
    nofileSetup
}
