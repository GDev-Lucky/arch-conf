#!/usr/bin/env bash

set -euo pipefail

su root -c 'pacman -Syu --needed ttf-nerd-fonts-symbols noto-fonts-emoji ttf-dejavu firefox'


