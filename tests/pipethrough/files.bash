#!/bin/bash

load fixture

readonly foo="${BATS_TMPDIR}/foo"
readonly bar="${BATS_TMPDIR}/b a r"
readonly barEscaped="${BATS_TMPDIR}/b\\ a\\ r"
readonly commandSingleQuoted="sed -e 's/.*/& &/'"
readonly commandEscaped='sed -e s/.\*/\&\ \&/'
commandArgs=(sed -e 's/.*/& &/')

filesSetup()
{
    echo "FOO" > "$foo"
    echo "x" > "$bar"
}
setup()
{
    filesSetup
}
