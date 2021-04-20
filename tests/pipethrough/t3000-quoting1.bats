#!/usr/bin/env bats

setup()
{
    readonly bar="${BATS_TMPDIR}/b a r"; echo "x" > "$bar"
    readonly barEscaped="${BATS_TMPDIR}/b\\ a\\ r"
    readonly commandSingleQuoted="sed -e 's/.*/& &/'"
    readonly commandEscaped='sed -e s/.\*/\&\ \&/'
    commandArgs=(sed -e 's/.*/& &/')
}

assert_modifications()
{
    [ "$(< "$bar")" = 'x x' ]
}


@test "--command, file appended" {
    run pipethrough1 --verbose --command "$commandSingleQuoted" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "--command, file via {}" {
    run pipethrough1 --verbose --command "$commandSingleQuoted" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "simple, file appended" {
    run pipethrough1 --verbose "${commandArgs[@]}" "$bar"

    [ "${lines[0]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "simple, file via {}" {
    run pipethrough1 --verbose "${commandArgs[@]}" {} "$bar"

    [ "${lines[0]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}


@test "--piped --command, file appended" {
    run pipethrough1 --piped --verbose --command "$commandSingleQuoted" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted" ]
    assert_modifications
}

@test "--piped --command, file via {}" {
    run pipethrough1 --piped --verbose --command "$commandSingleQuoted {}" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "--piped simple, file appended" {
    run pipethrough1 --piped --verbose "${commandArgs[@]}" "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandEscaped" ]
    assert_modifications
}

@test "--piped simple, file via {}" {
    run pipethrough1 --piped --verbose "${commandArgs[@]}" {} "$bar"

    [ "${lines[0]}" = "< $barEscaped $commandEscaped $barEscaped" ]
    assert_modifications
}
