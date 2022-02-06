#!/usr/bin/env bats

setup()
{
    readonly foo="${BATS_TMPDIR}/foo"; echo "FOO" > "$foo"
    readonly bar="${BATS_TMPDIR}/b a r"; echo "x" > "$bar"
    readonly barEscaped="${BATS_TMPDIR}/b\\ a\\ r"
    readonly commandSingleQuoted="sed -i -e 's/.*/& &/'"
    readonly commandEscaped='sed -i -e s/.\*/\&\ \&/'
    commandArgs=(sed -i -e 's/.*/& &/')
}

assert_modifications()
{
    [ "$(< "$foo")" = 'FOO FOO' ]
    [ "$(< "$bar")" = 'x x' ]
}


@test "--command, two files appended" {
    run processEachFile --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $foo" ]
    [ "${lines[1]}" = "$commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "--command, two files via {}" {
    run processEachFile --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    [ "${lines[0]}" = "$commandSingleQuoted $foo" ]
    [ "${lines[1]}" = "$commandSingleQuoted $barEscaped" ]
    assert_modifications
}

@test "-- simple without ending --" {
    run processEachFile --verbose -- "${commandArgs[@]}" "$foo" "$bar"

    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: -- SIMPLECOMMAND [ARGUMENTS ...] must be concluded with --!" ]
    [ "${lines[2]%% *}" = "Usage:" ]
}

@test "-- simple --, two files appended" {
    run processEachFile --verbose -- "${commandArgs[@]}" -- "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "-- simple --, two files via {}" {
    run processEachFile --verbose -- "${commandArgs[@]}" {} -- "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "--exec simple without ending ;" {
    run processEachFile --verbose --exec "${commandArgs[@]}" "$foo" "$bar"

    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: -exec command must be concluded with ;!" ]
    [ "${lines[2]%% *}" = "Usage:" ]
}

@test "--exec simple ;, two files appended" {
    run processEachFile --verbose --exec "${commandArgs[@]}" \; "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "--exec simple ;, two files via {}" {
    run processEachFile --verbose --exec "${commandArgs[@]}" {} \; "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "-n simple, two files appended" {
    run processEachFile --verbose --command-arguments 4 "${commandArgs[@]}" "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}

@test "-n simple, two files via {}" {
    run processEachFile --verbose --command-arguments 5 "${commandArgs[@]}" {} "$foo" "$bar"

    [ "${lines[0]}" = "$commandEscaped $foo" ]
    [ "${lines[1]}" = "$commandEscaped $barEscaped" ]
    assert_modifications
}
