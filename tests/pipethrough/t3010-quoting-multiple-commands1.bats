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

assert_sequential_modifications()
{
    [ "$(< "$bar")" = 'bar bar
#bar' ]
}
assert_overwritten_modifications()
{
    [ "$(< "$bar")" = '#bar' ]
}
assert_piped_modifications()
{
    [ "$(< "$bar")" = '#bar bar' ]
}


@test "--command {} --command" {
    run pipethrough1 --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped | $commandTwoSingleQuoted" ]
    assert_piped_modifications
}

@test "--command {} simple" {
    run pipethrough1 --verbose --command "$commandSingleQuoted {}" "${commandTwoArgs[@]}" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped | $commandTwoEscaped" ]
    assert_piped_modifications
}


# These are a bit special: Both commands receive the input file and write
# sequentially into the file. That's why a PIPETHROUGH1_COMMAND_JOINER override
# is necessary.
@test "PIPETHROUGH1_COMMAND_JOINER=; --command {} --command {}" {
    PIPETHROUGH1_COMMAND_JOINER=';' run pipethrough1 --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped ; $commandTwoSingleQuoted $barEscaped" ]
    assert_sequential_modifications
}

@test "PIPETHROUGH1_COMMAND_JOINER=; --command {} simple {}" {
    export PIPETHROUGH1_COMMAND_JOINER=';'
    run pipethrough1 --verbose --command "$commandSingleQuoted {}" "${commandTwoArgs[@]}" {} "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped ; $commandTwoEscaped $barEscaped" ]
    assert_sequential_modifications
}


@test "--piped --command {} --command {}" {
    run pipethrough1 --piped --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted $barEscaped | $commandTwoSingleQuoted $barEscaped" ]
    assert_overwritten_modifications
}

@test "--piped --command {} simple {}" {
    run pipethrough1 --piped --verbose --command "$commandSingleQuoted {}" "${commandTwoArgs[@]}" {} "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted $barEscaped | $commandTwoEscaped $barEscaped" ]
    assert_overwritten_modifications
}


@test "--piped --command --command" {
    run pipethrough1 --piped --verbose --command "$commandSingleQuoted" --command "$commandTwoSingleQuoted" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted | $commandTwoSingleQuoted" ]
    assert_piped_modifications
}

@test "--piped --command simple" {
    run pipethrough1 --piped --verbose --command "$commandSingleQuoted" "${commandTwoArgs[@]}" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted | $commandTwoEscaped" ]
    assert_piped_modifications
}
