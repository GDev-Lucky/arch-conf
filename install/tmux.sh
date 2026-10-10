#!/usr/bin/env bash

root_install() { pacman -Syu --needed tmux; }

export -f root_install

su root -c 'root_install'


mkdir -p ~/.config/tmux
touch ~/.config/tmux/tmux.conf

cat > ~/.config/tmux/tmux.conf <<'EOF'

set -g history-limit 20000

set -g base-index 1
setw -g pane-base-index 1

set -g renumber-windows on

setw -g mode-keys vi

set -g mouse off
EOF

echo "Installed tmux and loaded default config"
