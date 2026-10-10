#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed wayland wayland-protocols libinput libxkbcommon wlroots0.20 polkit ;
}

export -f root_install

su root -c 'root_install'


