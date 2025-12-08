#!/usr/bin/env bats

load fixture

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
    run -0 pipethrough1 --verbose --command "$commandSingleQuoted" "$bar"

    assert_line -n 0 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "--command, file via {}" {
    run -0 pipethrough1 --verbose --command "$commandSingleQuoted {}" "$bar"

    assert_line -n 0 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "--command, file appended after --" {
    run -0 pipethrough1 --verbose --command "$commandSingleQuoted" -- "$bar"

    assert_line -n 0 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "simple, file appended" {
    run -0 pipethrough1 --verbose "${commandArgs[@]}" "$bar"

    assert_line -n 0 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "simple, file via {}" {
    run -0 pipethrough1 --verbose "${commandArgs[@]}" {} "$bar"

    assert_line -n 0 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "simple after --, file appended" {
    run -0 pipethrough1 --verbose -- "${commandArgs[@]}" "$bar"

    assert_line -n 0 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "--exec, file appended after --" {
    run -0 pipethrough1 --verbose --exec "${commandArgs[@]}" \; -- "$bar"

    assert_line -n 0 "$commandEscaped $barEscaped"
    assert_modifications
}


@test "--piped --command, file appended" {
    run -0 pipethrough1 --piped --verbose --command "$commandSingleQuoted" "$bar"

    assert_line -n 0 "< $barEscaped $commandSingleQuoted"
    assert_modifications
}

@test "--piped --command, file via {}" {
    run -0 pipethrough1 --piped --verbose --command "$commandSingleQuoted {}" "$bar"

    assert_line -n 0 "< $barEscaped $commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "--piped simple, file appended" {
    run -0 pipethrough1 --piped --verbose "${commandArgs[@]}" "$bar"

    assert_line -n 0 "< $barEscaped $commandEscaped"
    assert_modifications
}

@test "--piped simple, file via {}" {
    run -0 pipethrough1 --piped --verbose "${commandArgs[@]}" {} "$bar"

    assert_line -n 0 "< $barEscaped $commandEscaped $barEscaped"
    assert_modifications
}
