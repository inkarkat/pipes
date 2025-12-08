#!/usr/bin/env bats

load fixture

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
    run -0 processEachFile --verbose --command "$commandSingleQuoted" "$foo" "$bar"

    assert_line -n 0 "$commandSingleQuoted $foo"
    assert_line -n 1 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "--command, two files via {}" {
    run -0 processEachFile --verbose --command "$commandSingleQuoted {}" "$foo" "$bar"

    assert_line -n 0 "$commandSingleQuoted $foo"
    assert_line -n 1 "$commandSingleQuoted $barEscaped"
    assert_modifications
}

@test "-- simple --, two files appended" {
    run -0 processEachFile --verbose -- "${commandArgs[@]}" -- "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "-- simple --, two files via {}" {
    run -0 processEachFile --verbose -- "${commandArgs[@]}" {} -- "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "--exec simple ;, two files appended" {
    run -0 processEachFile --verbose --exec "${commandArgs[@]}" \; "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "--exec simple ;, two files via {}" {
    run -0 processEachFile --verbose --exec "${commandArgs[@]}" {} \; "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "-n simple, two files appended" {
    run -0 processEachFile --verbose --command-arguments 4 "${commandArgs[@]}" "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}

@test "-n simple, two files via {}" {
    run -0 processEachFile --verbose --command-arguments 5 "${commandArgs[@]}" {} "$foo" "$bar"

    assert_line -n 0 "$commandEscaped $foo"
    assert_line -n 1 "$commandEscaped $barEscaped"
    assert_modifications
}
