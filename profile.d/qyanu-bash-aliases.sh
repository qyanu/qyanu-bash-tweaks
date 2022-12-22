#!/bin/bash
# some shortcuts
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias lsa="ls -alhi --color=auto"
alias psa="ps -Alf"
alias apgdef="apg -m22 -x22 -a1 -Mncl"
alias grep="grep --color"
alias whatismyip="curl -s https://dyndns.qyanu.net/whatismyip"
