#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed gcc;
}

export -f root_install

su root -c 'root_install'
