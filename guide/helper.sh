#!/usr/bin/env bash

run_in_pane() {
 local pane="$1"
shift
 
 if [[ "$pane" =~ ^[0-9]+$ ]]; then
  tmux send-keys -t ":.$pane" q Enter
  tmux send-keys -t ":.$pane" C-\\
  tmux send-keys -t ":.$pane" "$*" Enter C-l
 else
  bash -c "$*"
 fi
}

guide=~/lazy-arch/guide/guide.txt 

current=$current

cato() { run_in_pane ${!#} "grep -ni '^== ' $guide | less"; }

line() { run_in_pane ${!#} "sed -n \"${1},${2}p\" $guide | less"; }

ed() { run_in_pane ${!#} "cat -n $current | less"; }
sedi() { sed -i "${1}" $current; }
man() { run_in_pane ${!#} "curl -sL https://man.archlinux.org/man/${1}.txt | less"; }
echo "Loaded guide helpers."
