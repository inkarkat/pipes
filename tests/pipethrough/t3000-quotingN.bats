#!/usr/bin/env bats

load fixture

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
    run -0 pipethrough --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    assert_line -n 0 "$commandSingleQuoted $foo"
    assert_line -n 1 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "--command, two files via {}" {
    run -0 pipethrough --verbose --command "$commandSingleQuoted {}" "$foo" "$bar"

    assert_line -n 0 "$commandSingleQuoted $foo"
    assert_line -n 1 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "--command, two files appended after --" {
    run -0 pipethrough --verbose --command "$commandSingleQuoted" -- "$foo" "$bar"

    assert_line -n 0 "$commandSingleQuoted $foo"
    assert_line -n 1 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "-- simple without ending --" {
    run -2 pipethrough --verbose -- "${commandArgs[@]}" "$foo" "$bar"
    assert_line -n 0 "ERROR: -- SIMPLECOMMAND [ARGUMENT ...] must be concluded with --"
    assert_line -n 2 -e "^Usage:"
}

@test "-- simple --, two files appended" {
    run -0 pipethrough --verbose -- "${commandArgs[@]}" -- "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "-- simple --, two files via {}" {
    run -0 pipethrough --verbose -- "${commandArgs[@]}" {} -- "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "--exec simple without ending ;" {
    run -2 pipethrough --verbose --exec "${commandArgs[@]}" "$foo" "$bar"
    assert_line -n 0 "ERROR: --exec command must be concluded with ';'"
    assert_line -n 2 -e "^Usage:"
}

@test "--exec simple ;, two files appended" {
    run -0 pipethrough --verbose --exec "${commandArgs[@]}" \; "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "--exec simple ;, two files appended after --" {
    run -0 pipethrough --verbose --exec "${commandArgs[@]}" \; -- "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "--exec simple ; with custom end" {
    PIPETHROUGH_EXEC_END=END run -0 pipethrough --verbose --exec "${commandArgs[@]}" END "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "--exec simple ;, two files via {}" {
    run -0 pipethrough --verbose --exec "${commandArgs[@]}" {} \; "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "-n simple, two files appended" {
    run -0 pipethrough --verbose --command-arguments 3 "${commandArgs[@]}" "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "-n simple, two files via {}" {
    run -0 pipethrough --verbose --command-arguments 4 "${commandArgs[@]}" {} "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}


@test "--piped --command, two files appended" {
    run -0 pipethrough --piped --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    assert_line -n 0 "< $foo $commandSingleQuoted"
    assert_line -n 1 "< $barEscaped $commandSingleQuoted"
    assert_modifications
}

@test "--piped --command, two files via {}" {
    run -0 pipethrough --piped --verbose --command "$commandSingleQuoted {}" "$foo" "$bar"

    assert_line -n 0 "< $foo $commandSingleQuoted $foo"
    assert_line -n 1 "< $barEscaped $commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "--piped -- simple --, two files appended" {
    run -0 pipethrough --piped --verbose -- "${commandArgs[@]}" -- "$foo" "$bar"

    assert_line -n 0 "< $foo $commandEscaped"
    assert_line -n 1 "< $barEscaped $commandEscaped"
    assert_modifications
}

@test "--piped -- simple --, two files via {}" {
    run -0 pipethrough --piped --verbose -- "${commandArgs[@]}" {} -- "$foo" "$bar"

    assert_line -n 0 "< $foo $commandEscaped $foo"
    assert_line -n 1 "< $barEscaped $commandEscaped $barEscaped"
    assert_modifications
}

@test "--piped --exec simple ;, two files appended" {
    run -0 pipethrough --piped --verbose --exec "${commandArgs[@]}" \; "$foo" "$bar"

    assert_line -n 0 "< $foo $commandEscaped"
    assert_line -n 1 "< $barEscaped $commandEscaped"
    assert_modifications
}

@test "--piped --exec simple ;, two files via {}" {
    run -0 pipethrough --piped --verbose --exec "${commandArgs[@]}" {} \; "$foo" "$bar"

    assert_line -n 0 "< $foo $commandEscaped $foo"
    assert_line -n 1 "< $barEscaped $commandEscaped $barEscaped"
    assert_modifications
}

@test "--piped -n simple, two files appended" {
    run -0 pipethrough --piped --verbose --command-arguments 3 "${commandArgs[@]}" "$foo" "$bar"

    assert_line -n 0 "< $foo $commandEscaped"
    assert_line -n 1 "< $barEscaped $commandEscaped"
    assert_modifications
}

@test "--piped -n simple, two files via {}" {
    run -0 pipethrough --piped --verbose --command-arguments 4 "${commandArgs[@]}" {} "$foo" "$bar"

    assert_line -n 0 "< $foo $commandEscaped $foo"
    assert_line -n 1 "< $barEscaped $commandEscaped $barEscaped"
    assert_modifications
}
