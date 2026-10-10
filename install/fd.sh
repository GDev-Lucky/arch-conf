#!/usr/bin/env bash

root_install() { 
    pacman -Syu --needed fd
}

export -f root_install

su root -c "root_install"

echo "File finder (fd) installed"
