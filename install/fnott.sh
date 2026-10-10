#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed fnott
}

export -f root_install

su root -c 'root_install'

CONFIG_ROOT=~/.config/fnott

mkdir -p $CONFIG_ROOT 

cat > $CONFIG_ROOT/fnott.ini <<'EOF'
anchor=top-right

edge-margin-vertical=10
edge-margin-horizontal=10

notification-margin=6

progress-color=41a7fcff

border-size=1
border-radius=4

title-format=<b><i>%a%A</i></b>\n
summary-format=<b>%s\n</b>
body-format=%b

title-font=:size=10
summary-font=:size=14
body-font=:size=11

min-width=350
max-width=500

padding-horizontal=18
padding-vertical=14

[low]
background=202838ff
border-color=283347ff

title-color=67f9aaff
summary-color=93a4c3ff
body-color=6f7f9aff

[normal]
background=202838ff
border-color=41a7fcff
title-color=93a4c3ff
summary-color=abb2bfff
body-color=93a4c3ff

[critical]
background=202838ff
border-color=f65866ff

title-color=f65866ff
summary-color=abb2bfff
body-color=93a4c3ff
EOF

