#!/usr/bin/env bash

# [Adding Colors to man](https://russellparker.me/post/2018/02/23/adding-colors-to-man/)
# [Tinkering in the terminal with tput](https://www.n0nb.us/blog/2020/02/tinkering-in-the-terminal-with-tput/)
# [Documentation on LESS_TERMCAP_* variables?](https://unix.stackexchange.com/a/108840)

export LESS_TERMCAP_md="$(tput bold; tput setaf 14)" # "${TXT[bold]}${TXT[CYAN]}" # start bold
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # "${TXT[bold]}${TXT[green]}" # start blink
export LESS_TERMCAP_mr=$(tput rev) # start reverse
export LESS_TERMCAP_mh=$(tput dim) # start half-bright
export LESS_TERMCAP_me="$(tput sgr0)" # "${TXT[reset]}" # turn off all attributes
export LESS_TERMCAP_so="$(tput setab 4; tput bold; tput setaf 14)" # "${TXT[blueBG]}${TXT[bold]}${TXT[CYAN]}" # start standout
export LESS_TERMCAP_se="$(tput sgr0)" # "$(tput rmso)${TXT[reset]}" # stop standout
export LESS_TERMCAP_us="$(tput bold; tput setaf 12)" # "${TXT[ital]}${TXT[cyan]}" # start underline
export LESS_TERMCAP_ue="$(tput sgr0)" # "$(tput ritm)${TXT[reset]}" # stop underline
