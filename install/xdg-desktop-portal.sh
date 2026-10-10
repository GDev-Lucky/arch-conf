#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed xdg-desktop-portal xdg-desktop-portal-wlr
}

export -f root_install

su root -c 'root_install'

CONFIG="$HOME/.config/xdg-desktop-portal/"

mkdir -p $CONFIG

cat > $CONFIG/portals.conf <<'EOF'
[preferred]
org.freedesktop.impl.portal.ScreenCast=wlr
org.freedesktop.impl.portal.Screenshot=wlr
org.freedesktop.impl.portal.FileChooser=termfilechooser
EOF

