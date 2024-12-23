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
    run pipethrough --verbose --command "$commandSingleQuoted {}" "$foo" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $foo" ]
    [ "${lines[1]}" = "$commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "-- simple without ending --" {
    run pipethrough --verbose -- "${commandArgs[@]}" "$foo" "$bar"

    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: -- SIMPLECOMMAND [ARGUMENT ...] must be concluded with --" ]
    [ "${lines[2]%% *}" = "Usage:" ]
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

@test "--exec simple without ending ;" {
    run pipethrough --verbose --exec "${commandArgs[@]}" "$foo" "$bar"

    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: --exec command must be concluded with ';'" ]
    [ "${lines[2]%% *}" = "Usage:" ]
}

@test "--exec simple ;, two files appended" {
    run pipethrough --verbose --exec "${commandArgs[@]}" \; "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "--exec simple ; with custom end" {
    PIPETHROUGH_EXEC_END=END run pipethrough --verbose --exec "${commandArgs[@]}" END "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "--exec simple ;, two files via {}" {
    run pipethrough --verbose --exec "${commandArgs[@]}" {} \; "$foo" "$bar"

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

    [ "${lines[0]}" = "< $foo $commandSingleQuoted" ]
    [ "${lines[1]}" = "< $barEscaped $commandSingleQuoted" ]
    assert_modifications
}

@test "--piped --command, two files via {}" {
    run pipethrough --piped --verbose --command "$commandSingleQuoted {}" "$foo" "$bar"

    [ "${lines[0]}" = "< $foo $commandSingleQuoted $foo" ]
    [ "${lines[1]}" = "< $barEscaped $commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "--piped -- simple --, two files appended" {
    run pipethrough --piped --verbose -- "${commandArgs[@]}" -- "$foo" "$bar"

    [ "${lines[0]}" = "< $foo $commandEscaped" ]
    [ "${lines[1]}" = "< $barEscaped $commandEscaped" ]
    assert_modifications
}

@test "--piped -- simple --, two files via {}" {
    run pipethrough --piped --verbose -- "${commandArgs[@]}" {} -- "$foo" "$bar"

    [ "${lines[0]}" = "< $foo $commandEscaped $foo" ]
    [ "${lines[1]}" = "< $barEscaped $commandEscaped $barEscaped" ]
    assert_modifications
}

@test "--piped --exec simple ;, two files appended" {
    run pipethrough --piped --verbose --exec "${commandArgs[@]}" \; "$foo" "$bar"

    [ "${lines[0]}" = "< $foo $commandEscaped" ]
    [ "${lines[1]}" = "< $barEscaped $commandEscaped" ]
    assert_modifications
}

@test "--piped --exec simple ;, two files via {}" {
    run pipethrough --piped --verbose --exec "${commandArgs[@]}" {} \; "$foo" "$bar"

    [ "${lines[0]}" = "< $foo $commandEscaped $foo" ]
    [ "${lines[1]}" = "< $barEscaped $commandEscaped $barEscaped" ]
    assert_modifications
}

@test "--piped -n simple, two files appended" {
    run pipethrough --piped --verbose --command-arguments 3 "${commandArgs[@]}" "$foo" "$bar"

    [ "${lines[0]}" = "< $foo $commandEscaped" ]
    [ "${lines[1]}" = "< $barEscaped $commandEscaped" ]
    assert_modifications
}

@test "--piped -n simple, two files via {}" {
    run pipethrough --piped --verbose --command-arguments 4 "${commandArgs[@]}" {} "$foo" "$bar"

    [ "${lines[0]}" = "< $foo $commandEscaped $foo" ]
    [ "${lines[1]}" = "< $barEscaped $commandEscaped $barEscaped" ]
    assert_modifications
}
