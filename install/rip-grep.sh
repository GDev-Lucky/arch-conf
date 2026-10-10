#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed ripgrep;
}

export -f root_install

su root -c "root_install"

echo "Installed rip-grep"
