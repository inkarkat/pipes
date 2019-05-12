#!/usr/bin/env bats

setup()
{
    readonly foo="${BATS_TMPDIR}/foo"; echo "FOO" > "$foo"
    readonly bar="${BATS_TMPDIR}/b a r"; echo "x" > "$bar"
}

assert_modifications()
{
    [ "$(< "$foo")" = 'FOO FOO' ]
    [ "$(< "$bar")" = 'x x' ]
}

@test "--command, two files appended" {
    run pipethrough --verbose --command "sed -e 's/.*/& &/'" "$foo" "$bar"

    [ "${lines[0]}" = "sed -e 's/.*/& &/' /tmp/foo" ]
    [ "${lines[1]}" = "sed -e 's/.*/& &/' /tmp/b\ a\ r" ]
    assert_modifications
}

@test "--command, two files via {}" {
    run pipethrough --verbose --command "sed -e 's/.*/& &/' {}" "$foo" "$bar"

    [ "${lines[0]}" = "sed -e 's/.*/& &/' /tmp/foo " ]
    [ "${lines[1]}" = "sed -e 's/.*/& &/' /tmp/b\ a\ r " ]
    assert_modifications
}

@test "-- simple --, two files appended" {
    run pipethrough --verbose -- sed -e 's/.*/& &/' -- "$foo" "$bar"

    [ "${lines[0]}" = 'sed -e s/.\*/\&\ \&/ /tmp/foo' ]
    [ "${lines[1]}" = 'sed -e s/.\*/\&\ \&/ /tmp/b\ a\ r' ]
    assert_modifications
}

@test "-- simple --, two files via {}" {
    run pipethrough --verbose -- sed -e 's/.*/& &/' {} -- "$foo" "$bar"

    [ "${lines[0]}" = 'sed -e s/.\*/\&\ \&/ /tmp/foo ' ]
    [ "${lines[1]}" = 'sed -e s/.\*/\&\ \&/ /tmp/b\ a\ r ' ]
    assert_modifications
}

@test "; simple ;, two files appended" {
    run pipethrough --verbose \; sed -e 's/.*/& &/' \; "$foo" "$bar"

    [ "${lines[0]}" = 'sed -e s/.\*/\&\ \&/ /tmp/foo' ]
    [ "${lines[1]}" = 'sed -e s/.\*/\&\ \&/ /tmp/b\ a\ r' ]
    assert_modifications
}

@test "; simple ;, two files via {}" {
    run pipethrough --verbose \; sed -e 's/.*/& &/' {} \; "$foo" "$bar"

    [ "${lines[0]}" = 'sed -e s/.\*/\&\ \&/ /tmp/foo ' ]
    [ "${lines[1]}" = 'sed -e s/.\*/\&\ \&/ /tmp/b\ a\ r ' ]
    assert_modifications
}

@test "-n simple, two files appended" {
    run pipethrough --verbose --command-arguments 3 sed -e 's/.*/& &/' "$foo" "$bar"

    [ "${lines[0]}" = 'sed -e s/.\*/\&\ \&/ /tmp/foo' ]
    [ "${lines[1]}" = 'sed -e s/.\*/\&\ \&/ /tmp/b\ a\ r' ]
    assert_modifications
}

@test "-n simple, two files via {}" {
    run pipethrough --verbose --command-arguments 4 sed -e 's/.*/& &/' {} "$foo" "$bar"

    [ "${lines[0]}" = 'sed -e s/.\*/\&\ \&/ /tmp/foo ' ]
    [ "${lines[1]}" = 'sed -e s/.\*/\&\ \&/ /tmp/b\ a\ r ' ]
    assert_modifications
}
