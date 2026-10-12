#!/usr/bin/env bash
set -euo pipefail

CMP_TMP=()
BUILD_DIR=""

cleanup() {
    local status=$?
    trap - EXIT

    remove_pkgs CMP_TMP || status=1

    if [[ -n $BUILD_DIR ]]; then
        rm -rf -- "$BUILD_DIR" || status=1
    fi

    if (( status == 0 )); then
        echo "Neovim installation finished"
        echo "Run nvim to open"
        echo "Configs: $USER_CONFIG/nvim"
    else
        echo "Neovim installation failed" >&2
    fi

    exit "$status"
}

trap cleanup EXIT

install_nvim() {
    as_root "Install/update Neovim" \
        pacman -Syu --needed neovim 

    if ! ask_yes_no "Configure Neovim? (WARNING: previous configuration will be lost)"; then
        exit 0
    fi

    rm -rf -- "$USER_CONFIG/nvim"
    ln -s -- "$CONFIG/nvim" "$USER_CONFIG/nvim"

    nvim --headless \
        -c 'lua vim.pack.update(nil, { force = true })' \
        -c 'qa!'

    printf "\n"
}

build_cmp() {
    BUILD_DIR=$(mktemp -d "$TMP/nvim.XXXXXXXX")

    mkdir -p -- "$BUILD_DIR"/{cargo,target,tmp}

    pkgs CMP_TMP rust gcc

    CARGO_HOME="$BUILD_DIR/cargo" \
    CARGO_TARGET_DIR="$BUILD_DIR/target" \
    TMPDIR="$BUILD_DIR/tmp" \
    nvim --headless \
        -c "lua local c = require('blink.cmp'); c.build({ force = true }):pwait(); assert(c.library_available(), 'Blink build failed')" \
        -c 'qa!'

    printf "\n"

    echo "Built Blink.cmp successfully!"
}

install_nvim_lsp() {
    local line

    line=$(grep -nFm1 '# --@INSTALLER_SET 0' "$BIN/nvim-lsp" | cut -d: -f1)

    [[ -n $line ]] || {
        echo "Installer marker not found" >&2
        return 1
    }

    ((++line))

    sed -i "${line}c\\SCRIPT_DIR=\"$SCRIPT\"" "$BIN/nvim-lsp"

    ln -sfn "$BIN/nvim-lsp" "$USER_BIN/nvim-lsp"

    echo "Added nvim-lsp to $USER_BIN"
}

install_nvim

if ask_yes_no "Would you like to build/rebuild Blink.cmp?"; then
    build_cmp
fi

if ask_yes_no "Would you like to install nvim-lsp (lsp installer) ?"; then
    install_nvim_lsp
fi

