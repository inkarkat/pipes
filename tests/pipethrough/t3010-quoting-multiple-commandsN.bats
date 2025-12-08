#!/usr/bin/env bats

load fixture

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
    run -0 pipethrough --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted" "$bar"

    assert_line -n 0 "$commandSingleQuoted $barEscaped | $commandTwoSingleQuoted"
    assert_piped_modifications
}


# These are a bit special: Both commands receive the input file and write
# sequentially into the file. That's why a PIPETHROUGH1_COMMAND_JOINER override
# is necessary.
@test "PIPETHROUGH_COMMAND_JOINER=; --command {} --command {}" {
    PIPETHROUGH_COMMAND_JOINER=';' run -0 pipethrough --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    assert_line -n 0 "$commandSingleQuoted $barEscaped ; $commandTwoSingleQuoted $barEscaped"
    assert_sequential_modifications
}


@test "--exec {} --exec" {
    run -0 pipethrough --verbose --exec "${commandArgs[@]}" {} \; --exec "${commandTwoArgs[@]}" \; "$bar"

    assert_line -n 0 "$commandEscaped $barEscaped | $commandTwoEscaped"
    assert_piped_modifications
}

@test "--command {} --exec" {
    run -0 pipethrough --verbose --command "$commandSingleQuoted {}" --exec "${commandTwoArgs[@]}" \; "$bar"

    assert_line -n 0 "$commandSingleQuoted $barEscaped | $commandTwoEscaped"
    assert_piped_modifications
}

@test "--exec {} --command" {
    run -0 pipethrough --verbose --exec "${commandArgs[@]}" {} \; --command "$commandTwoSingleQuoted" "$bar"

    assert_line -n 0 "$commandEscaped $barEscaped | $commandTwoSingleQuoted"
    assert_piped_modifications
}



@test "--piped --command {} --command {}" {
    run -0 pipethrough --piped --verbose --command "$commandSingleQuoted {}" --command "$commandTwoSingleQuoted {}" "$bar"

    assert_line -n 0 "< $barEscaped $commandSingleQuoted $barEscaped | $commandTwoSingleQuoted $barEscaped"
    assert_overwritten_modifications
}


@test "--piped --command --command" {
    run -0 pipethrough --piped --verbose --command "$commandSingleQuoted" --command "$commandTwoSingleQuoted" "$bar"

    assert_line -n 0 "< $barEscaped $commandSingleQuoted | $commandTwoSingleQuoted"
    assert_piped_modifications
}
