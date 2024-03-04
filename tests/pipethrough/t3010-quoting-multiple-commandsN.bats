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
    run pipethrough --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped | $commandTwoSingleQuoted" ]
    assert_piped_modifications
}

@test "--command {} -- simple {} --" {
    run pipethrough --verbose --command "$commandSingleQuoted {}" -- "${commandTwoArgs[@]}" -- "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped | $commandTwoEscaped" ]
    assert_piped_modifications
}


# These are a bit special: Both commands receive the input file and write
# sequentially into the file. That's why a PIPETHROUGH1_COMMAND_JOINER override
# is necessary.
@test "PIPETHROUGH_COMMAND_JOINER=; --command {} --command {}" {
    PIPETHROUGH_COMMAND_JOINER=';' run pipethrough --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped ; $commandTwoSingleQuoted $barEscaped" ]
    assert_sequential_modifications
}

@test "PIPETHROUGH_COMMAND_JOINER=; --command {} -- simple {} --" {
    PIPETHROUGH_COMMAND_JOINER=';' run pipethrough --verbose --command "$commandSingleQuoted {}" -- "${commandTwoArgs[@]}" {} -- "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped ; $commandTwoEscaped $barEscaped" ]
    assert_sequential_modifications
}


@test "--exec {} --exec" {
    run pipethrough --verbose --exec "${commandArgs[@]}" {} \; --exec "${commandTwoArgs[@]}" \; "$bar"

    [ "${lines[0]}" = "$commandEscaped $barEscaped | $commandTwoEscaped" ]
    assert_piped_modifications
}

@test "--exec {} -- simple --" {
    run pipethrough --verbose --exec "${commandArgs[@]}" {} \; -- "${commandTwoArgs[@]}" -- "$bar"

    [ "${lines[0]}" = "$commandEscaped $barEscaped | $commandTwoEscaped" ]
    assert_piped_modifications
}

@test "--command {} --exec" {
    run pipethrough --verbose --command "$commandSingleQuoted {}" --exec "${commandTwoArgs[@]}" \; "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped | $commandTwoEscaped" ]
    assert_piped_modifications
}

@test "--exec {} --command" {
    run pipethrough --verbose --exec "${commandArgs[@]}" {} \; --command "$commandTwoSingleQuoted" "$bar"

    [ "${lines[0]}" = "$commandEscaped $barEscaped | $commandTwoSingleQuoted" ]
    assert_piped_modifications
}



@test "--piped --command {} --command {}" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted $barEscaped | $commandTwoSingleQuoted $barEscaped" ]
    assert_overwritten_modifications
}

@test "--piped --command {} -- simple {} --" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted {}" -- "${commandTwoArgs[@]}" {} -- "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted $barEscaped | $commandTwoEscaped $barEscaped" ]
    assert_overwritten_modifications
}


@test "--piped --command --command" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted" --command "$commandTwoSingleQuoted" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted | $commandTwoSingleQuoted" ]
    assert_piped_modifications
}

@test "--piped --command -- simple --" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted" -- "${commandTwoArgs[@]}" -- "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted | $commandTwoEscaped" ]
    assert_piped_modifications
}
