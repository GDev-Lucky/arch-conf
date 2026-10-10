#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed fzf;
}

export -f root_install

su root -c "root_install"

echo "Fuzzy selector (fzf) installed" 
