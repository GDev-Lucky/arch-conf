#!/usr/bin/env bash

BUILD_ROOT=~/dwl-build-tmp
VERSION="0.9"

download() {
    git clone --branch v0.9 --depth 1 https://codeberg.org/dwl/dwl.git $BUILD_ROOT;
    echo "Dwl repo downloaded at $BUILD_ROOT"
}

build() {

    echo "Building..."

    set -euo pipefail

    if [[ ! -f config.h ]] then
        cp config.def.h config.h
    fi

    SCANNER=/usr/bin/wayland-scanner
    PROTOCOLS=/usr/share/wayland-protocols

    "$SCANNER" enum-header "$PROTOCOLS/staging/cursor-shape/cursor-shape-v1.xml" cursor-shape-v1-protocol.h

    "$SCANNER" enum-header "$PROTOCOLS/staging/ext-image-copy-capture/ext-image-copy-capture-v1.xml" ext-image-copy-capture-v1-protocol.h

    "$SCANNER" enum-header "$PROTOCOLS/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml" pointer-constrains-unstable-v1-protocl.h

    "$SCANNER" enum-header protocols/wlr-layer-shell-unstable-v1.xml wlr-layer-shell-unstable-v1-protocol.h

    "$SCANNER" server-header protocols/wlr-output-power-management-unstable-v1.xml wlr-output-power-management-unstable-v1-protocol.h

    "$SCANNER" server-header "$PROTOCOLS/stable/xdg-shell/xdg-shell.xml" xdg-shell-protocol.h

    CFLAGS=(
        -I.
        -I/usr/include/wlroots-0.20
        -I/usr/include/pixman-1
        -I/usr/include/libdrm

        -DWLR_USE_UNSTABLE
        -D_POSIX_C_SOURCE=200809L
        "-DVERSION=\"$VERSION\""

        -Wall
        -Wextra
        -Wpedantic

        -Wdeclaration-after-statement
        -Wno-unused-parameter
        -Wshadow
        -Werror=strict-prototypes
        -Werror=implicit
        -Werror=return-type

        -Werror=incompatible-pointer-types
        -Wfloat-conversion
    )

    gcc "${CFLAGS[@]}" -c dwl.c -o dwl.o

    gcc dwl.o -lwlroots-0.20 -lwayland-server -lxkbcommon -linput -lm -o dwl

    echo "Build completed!"
}

if [[ $1 == "build" ]]; then
    (
        cd $BUILD_ROOT
        build
    )
elif [[ $1 == "download" ]]; then
    download
elif [[ $1 == "install" ]]; then
    install -Dm755 $BUILD_ROOT/dwl ~/.local/out
else
    echo "$1 is not a valid argument"
fi
