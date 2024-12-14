# Pipes

_Commands that simplify processing file contents through a pipeline of shell commands._

![Build Status](https://github.com/inkarkat/pipes/actions/workflows/build.yml/badge.svg)

Pipelines are a mainstay of Unix shell processing. However, the setup can be cumbersome, like when the output should go back into the original file(s), or if a different number of intermediate files then gets recombined into a final set of files (like in a map-reduce scenario).
These commands simplify the setup of such pipelines for some common use cases.

### Dependencies

* Bash
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.
* The [shell/completions.sh](shell/completions.sh) script (meant to be sourced in `.bashrc`) defines Bash completions for the provided commands.
* The [profile/exports.sh](profile/exports.sh) sets up configuration; it only needs to be sourced once, e.g. from your `.profile`.
