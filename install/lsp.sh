#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
    echo "Usage: $0 <package> <lsp-name>"
    exit 1
fi

package=$1
lsp=$2
config="$HOME/.config/nvim/init.lua"

if [[ ! $package =~ ^[a-zA-Z0-9@._/+:-]+$ ]] ||
   [[ ! $lsp =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo "Invalid package or LSP name"
    exit 1
fi

if [[ ! -f $config ]] ||
   ! grep -Eq -- '^[[:space:]]*--AUTO-LSP[[:space:]]*$' "$config"; then
    echo "Missing init.lua or AUTO-LSP marker"
    exit 1
fi

# Install package
su -c "pacman -Syu --needed $package"

# Avoid duplicates
if grep -Eq "^[[:space:]]*\"${lsp}\",[[:space:]]*$" "$config"; then
    echo "$lsp is already configured"
    exit 0
fi

# Insert LSP into Lua table
sed -i "/^[[:space:]]*--AUTO-LSP[[:space:]]*$/i\\    \"$lsp\"," "$config"

echo "Installed and enabled: $lsp"
