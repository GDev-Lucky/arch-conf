#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed pipewire pipewire-audio pipewire-pulse pipewire-alsa wireplumber rtkit
}

export -f root_install

su root -c 'root_install'

