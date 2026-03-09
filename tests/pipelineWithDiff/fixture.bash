#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

typeset -gra changeCommand=(sed -e 's/O\+/i/')
typeset -gra duplicateCommand=(sed -e 's/.*/&&/g')
typeset -gra braceCommand=(sed -e 's/.*/[&]/g')
typeset -gra failCommand=(sed -e 'q 1')
typeset -gra modifyAndFailCommand=(sed -e 's/O\+/i/g' -e 'q 42')
typeset -gra noopCommand=(cat)
