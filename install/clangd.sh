#!/usr/bin/env bash

set -euo pipefail

OUT=$HOME/.local/out
BIN=$HOME/.local/bin

rm -rf -- $OUT/clangd $BIN/clangd /tmp/clangd.zip

mkdir -p $OUT/clangd $BIN

curl -fL https://github.com/clangd/clangd/releases/download/22.1.6/clangd-linux-22.1.6.zip -o /tmp/clangd.zip

bsdtar -xf /tmp/clangd.zip -C $OUT/clangd --strip-components 1 

ln -sfn $OUT/clangd/bin/clangd $BIN/clangd

rm -rf /tmp/clangd.zip
