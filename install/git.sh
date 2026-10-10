#!/usr/bin/env bash

root_install() {
 pacman -Sp --needed --print-format '%n %v %s %d' git | less
 pacman -Syu --needed git
}

export -f root_install

su root -c 'root_install'

echo "Enter username"
read user
git config --global user.name user
echo "Enter email"
read email
git config --global user.email email
