#!/usr/bin/env bash

root_install() { pacman -Syu --needed openssh; }

export -f root_install

su root -c "root_install"

