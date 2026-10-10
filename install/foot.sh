#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed ttf-dejavu foot;
}

export -f root_install

su root -c "root_install"

mkdir -p ~/.config/foot

cat > ~/.config/foot/foot.ini <<'EOF'
[main]
font=DejaVu Sans Mono:size=11
pad=4x4

[scrollback]
lines=10000
EOF

echo "Installed and configured foot"
