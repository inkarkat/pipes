#!/usr/bin/env bats

setup()
{
    readonly bar="${BATS_TMPDIR}/b a r"; echo "bar" > "$bar"
    readonly barEscaped="${BATS_TMPDIR}/b\\ a\\ r"

    readonly commandSingleQuoted="sed -e 's/.*/& &/'"
    readonly commandEscaped='sed -e s/.\*/\&\ \&/'
    commandArgs=(sed -e 's/.*/& &/')

    readonly commandTwoSingleQuoted="sed -e 's/^/#&/'"
    readonly commandTwoEscaped='sed -e s/\^/#\&/'
    commandTwoArgs=(sed -e 's/^/#&/')
}

assert_modifications()
{
    [ "$(< "$bar")" = 'bar bar
#bar' ]
}


@test "--command {} --command {}" {
    run pipethrough --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped ; $commandTwoSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "--command {} -- simple {} --" {
    run pipethrough --verbose --command "$commandSingleQuoted {}" -- "${commandTwoArgs[@]}" {} -- "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped ; $commandTwoEscaped $barEscaped" ]
    assert_modifications
}


@test "--piped --command {} --command {}" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted $barEscaped ; $commandTwoSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "--piped --command {} -- simple {} --" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted {}" -- "${commandTwoArgs[@]}" {} -- "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted $barEscaped ; $commandTwoEscaped $barEscaped" ]
    assert_modifications
}
