#!/usr/bin/env bash
set -euo pipefail

file="$CONFIG/nvim/init.lua"
name=${2:-}

[[ $name =~ ^[a-zA-Z0-9_]+$ ]] || {
    echo "Invalid LSP name" >&2
    exit 1
}

[[ -f $file ]] || {
    echo "Missing $file" >&2
    exit 1
}

case ${1:-} in
add)
    [[ $# == 3 ]] || {
        echo "Usage: nvim-lsp add NAME PACKAGE_OR_BINARY" >&2
        exit 1
    }

    source=$3

    [[ $source != *$'\n'* && $source != *$'\r'* ]] || exit 1

    grep -Eq '^[[:space:]]*--AUTO-LSP[[:space:]]*$' "$file" || {
        echo "Missing --AUTO-LSP marker" >&2
        exit 1
    }

    if grep -Eq "^[[:space:]]*\"$name\"[[:space:]]*," "$file"; then
        echo "$name already configured"
        exit 0
    fi

    # Detect package or existing binary
    if pacman -Qq -- "$source" &>/dev/null ||
       pacman -Si -- "$source" &>/dev/null; then

        kind=pkg
        missing=()
        pkgs missing "$source"

    else
        kind=bin

        if [[ $source == */* ]]; then
            binary=$source
        else
            binary=$(command -v -- "$source") || {
                echo "Binary not found: $source" >&2
                exit 1
            }
        fi

        [[ -f $binary && -x $binary ]] || {
            echo "Not an executable file: $binary" >&2
            exit 1
        }

        source=$(realpath -s -- "$binary")
    fi

    # Add server before --AUTO-LSP
    sed -i "/^[[:space:]]*--AUTO-LSP[[:space:]]*$/i\\    \"$name\", -- AUTO-LSP $kind:$source" "$file"

    echo "Added $name ($kind:$source)"
    ;;

remove)
    [[ $# == 2 ]] || {
        echo "Usage: nvim-lsp remove NAME" >&2
        exit 1
    }

    # Find the server and its saved installation source
    line=$(grep -Em1 "^[[:space:]]*\"$name\",[[:space:]]*-- AUTO-LSP (pkg|bin):" "$file") || {
        echo "No auto-added server named $name" >&2
        exit 1
    }

    record=${line#*-- AUTO-LSP }
    kind=${record%%:*}
    source=${record#*:}

    # Remove only the matching auto-added entry
    sed -i "/^[[:space:]]*\"$name\",[[:space:]]*-- AUTO-LSP /d" "$file"

    echo "Removed $name from Neovim"

    if [[ $kind == pkg ]]; then

        if ask_yes_no "Also uninstall package $source?"; then
            packages=("$source")
            remove_pkgs packages
        fi

    else
        # Check whether pacman owns the binary
        if owner=$(pacman -Qoq -- "$source" 2>/dev/null); then

            if ask_yes_no "Binary belongs to $owner. Uninstall package?"; then
                packages=("$owner")
                remove_pkgs packages
            fi

        elif ask_yes_no "Delete unowned binary $source?"; then

            if [[ -w $(dirname -- "$source") ]]; then
                rm -f -- "$source"
            else
                as_root "Remove binary $source" rm -f -- "$source"
            fi
        fi
    fi
    ;;

*)
    echo "Usage: nvim-lsp {add NAME PACKAGE_OR_BINARY | remove NAME}" >&2
    exit 1
    ;;
esac

