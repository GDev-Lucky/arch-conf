#!/usr/bin/env bash
set -euo pipefail

root_install() {
    pacman -Syu --needed vimb
}

export -f root_install

CONFIG="$HOME/.config/vimb"
DOWNLOADS="$HOME/Downloads"
BIN="$HOME/.local/bin"

su root -c 'root_install'

mkdir -p $CONFIG
mkdir -p $DOWNLOADS
mkdir -p $BIN

cat > "$CONFIG/config" <<EOF

set home-page=about:blank
set dark-mode=on

set show-titlebar=off
set status-bar=on
set status-bar-show-settings=off
set input-autohide=on

set smooth-scrolling=off
set hardware-acceleration-policy=ondemand

set download-path=$DOWNLOADS

set media-playback-requires-user-gesture=on
set javascript-can-open-windows-automatically=off

set scripts=on
set images=on
set media=on
set webgl=on

set hint-keys=asdfghjkl
set hint-follow-last=on
set hint-keys-same-length=on

nnoremap x :tabclose<CR>

nnoremap <C-J> gt
nnoremap <C-K> gT

shortcut-add
sg=https://google.com/?q=$0
shortcut-default dd

set status-css=color:#93a4c3;background-color:#0c0e15;
set status-ssl-css=color:#8bcd5b;background-color:#0c0e15;
set status-ssl-invalid-css=color:#f65866;background-color:#0c0e15;

set input-css=color:#93a4c3; background-color:#1a212e;
set input-error-css=color:#f65866;background-color:#1a212e;

set completion-css=color:#94a4c3;background-color:#1a212e;
set completion-hover-css=color:#ffffff;background-color:#283347
set completion-selected-css=color:#ffffff;background-color:#283347

set stylesheet=on
EOF

cat > "$CONFIG/style.css" <<EOF
._hintlabel {
    background-color: #efbd5d !important;
    color: #0c0e15 !important;

    border: 1px solid #41a7fc !important;
    border-radius: 3px !important;

    font-wieght: bold !important;
    padding: 2px 4px !important;
}

._hintElem {
    outline: 2px solid #41a7fc !important;
}
EOF

cat > "$BIN/browser" <<'EOF'
#!/usr/bin/env bash

GDK_DEBUG=portals exec /usr/bin/vimb "$@" 
EOF

chmod +x "$BIN/browser"



