#!/usr/bin/env bash

CONFIG=$HOME/.makepkg.conf

touch $CONFIG

cat > $CONFIG <<'EOF'
# USE SU FOR AUTH
PACMAN_AUTH=(su root -c %c)

# PARALLEL OPTIMIZATION
MAKEFLAGS="-j$(nproc)"

# OPTIMIZE LOCALLY-BUILT PROGRAMS FOR OUR CPU
CFLAGS+=" -march=native -mtune=native"
CXXFLAGS+=" -march=native -mtune=native"

_set_flag()
{
    local array_name="$1"
    local flag="$2"
    local value="$3"

    local -n array="$array_name"
    local item
    local new=()

    for item in "${array[@]}" 
    do
        if [[ "$item" != "$flag" && "$item" != "!$flag" ]]
        then
            new+=("$item")
        fi
    done

    array=("${new[@]}" "$value")
}

# OPTION FLAGS 
_set_flag OPTIONS strip strip

_set_flag OPTIONS lto 'lto'

_set_flag OPTIONS debug '!debug'

_set_flag OPTIONS docs '!docs'

_set_flag OPTIONS libtool '!libtool'

_set_flag OPTIONS staticlibs '!staticlibs'

_set_flag OPTIONS emptydirs '!emptydirs'


# BUILD ENV FLAGS
_set_flag BUILDENV check 'check'

_set_flag BUILDENV distcc '!distcc'

_set_flag BUILDENV ccache '!ccache'

_set_flag BUILDENV sign '!sign'

unset -f _set_flag
EOF

su root -c "pacman -Syu --needed fakeroot"

echo "Updated makepkg config $CONFIG"
