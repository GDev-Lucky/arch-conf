#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed nvidia-open;
}

export -f root_install

su root -c "root_install"

echo "Reboot pc to load latest nvidia drivers"
