#!/usr/bin/env bats

setup()
{
    readonly foo="${BATS_TMPDIR}/foo"; echo "FOO" > "$foo"
    readonly bar="${BATS_TMPDIR}/b a r"; echo "x" > "$bar"
    readonly barEscaped="${BATS_TMPDIR}/b\\ a\\ r"
    readonly commandSingleQuoted="sed -e 's/.*/& &/'"
    readonly commandEscaped='sed -e s/.\*/\&\ \&/'
    commandArgs=(sed -e 's/.*/& &/')
}

assert_modifications()
{
    [ "$(< "$foo")" = 'FOO FOO' ]
    [ "$(< "$bar")" = 'x x' ]
}


@test "--command, two files appended" {
    run pipethrough --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $foo" ]
    [ "${lines[1]}" = "$commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "--command, two files via {}" {
    run pipethrough --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $foo" ]
    [ "${lines[1]}" = "$commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "-- simple --, two files appended" {
    run pipethrough --verbose -- "${commandArgs[@]}" -- "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "-- simple --, two files via {}" {
    run pipethrough --verbose -- "${commandArgs[@]}" {} -- "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "; simple ;, two files appended" {
    run pipethrough --verbose \; "${commandArgs[@]}" \; "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "; simple ;, two files via {}" {
    run pipethrough --verbose \; "${commandArgs[@]}" {} \; "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "-n simple, two files appended" {
    run pipethrough --verbose --command-arguments 3 "${commandArgs[@]}" "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "-n simple, two files via {}" {
    run pipethrough --verbose --command-arguments 4 "${commandArgs[@]}" {} "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}


@test "--piped --command, two files appended" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted < $foo" ]
    [ "${lines[1]}" = "$commandSingleQuoted < $barEscaped" ]
    assert_modifications
}

@test "--piped --command, two files via {}" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted {}" "$foo" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $foo < $foo" ]
    [ "${lines[1]}" = "$commandSingleQuoted $barEscaped < $barEscaped" ]
    assert_modifications
}

@test "--piped -- simple --, two files appended" {
    run pipethrough --piped --verbose -- "${commandArgs[@]}" -- "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped < $foo" ]
    [ "${lines[1]}" = "$commandEscaped < $barEscaped" ]
    assert_modifications
}

@test "--piped -- simple --, two files via {}" {
    run pipethrough --piped --verbose -- "${commandArgs[@]}" {} -- "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo < $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped < $barEscaped" ]
    assert_modifications
}

@test "--piped ; simple ;, two files appended" {
    run pipethrough --piped --verbose \; "${commandArgs[@]}" \; "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped < $foo" ]
    [ "${lines[1]}" = "$commandEscaped < $barEscaped" ]
    assert_modifications
}

@test "--piped ; simple ;, two files via {}" {
    run pipethrough --piped --verbose \; "${commandArgs[@]}" {} \; "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo < $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped < $barEscaped" ]
    assert_modifications
}

@test "--piped -n simple, two files appended" {
    run pipethrough --piped --verbose --command-arguments 3 "${commandArgs[@]}" "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped < $foo" ]
    [ "${lines[1]}" = "$commandEscaped < $barEscaped" ]
    assert_modifications
}

@test "--piped -n simple, two files via {}" {
    run pipethrough --piped --verbose --command-arguments 4 "${commandArgs[@]}" {} "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo < $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped < $barEscaped" ]
    assert_modifications
}
