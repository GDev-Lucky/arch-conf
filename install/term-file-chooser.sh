#!/usr/bin/env bash
set -euo pipefail

CACHE=$HOME/.cache/build
BUILD=$CACHE/terminal-file-chooser

mkdir -p $CACHE
rm -rf -- "$BUILD"

git clone https://aur.archlinux.org/xdg-desktop-portal-termfilechooser-hunkyburrito-git.git $BUILD

cd $BUILD

cat >> PKGBUILD <<'EOF'
makedepends+=(
    'cmake'
    'pkgconf'
    'meson'
    'ninja'
    'scdoc'
)

depends+=(
    'libinih'
)
EOF

makepkg -scri

cd $HOME

rm -rf $BUILD

CONFIG=$HOME/.config/xdg-desktop-portal-termfilechooser

mkdir -p $CONFIG

cat > $CONFIG/config <<'EOF'
[filechooser]
cmd=fzf-wrapper.sh
default_dir=$HOME
env=TERMCMD=foot
open_mode=suggested
save_mode=last
EOF

chmod +x $CONFIG/config

cat > $CONFIG/fzf-wrapper.sh <<'EOF'
#!/usr/bin/env bash

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"
debug="$6"

set -e

if [ "$debug" = 1 ]; then
    set -x
fi

termcmd="${TERMCMD:-foot}"

if [ -d "$path" ]; then
    start="$path"
elif [ -n "$path" ]; then
    start=$(dirname "$path")
else
    start="$HOME"
fi

[ -d "$start" ] || start="$HOME"

if [ "$save" = 1 ]; then
    suggested=""

    [ -n "$path" ] && suggested="$(basename "$path")"

    "$termcmd" sh -c '
        cd "$1" || exit 1

        dir=$(
            {
                printf ".\n"
                fd --type d --hidden --exclude .git 
            } | fzf --prompt="Directory > "
        ) || exit 1

        cd "$dir" || exit 1

        printf "Save as [%s]: $3"

        read -r name

        [ -n "$name" ] || name="$3"
        [ -n "$name" ] || exit 1

        printf "%s/%s\n" "$PWD" "$name" > "$2"
    ' sh "$start" "$out" "$suggested"

elif [ "$directory" = 1 ]; then
    
    "$termcmd" sh -c '
        cd "$1" || exit 1

        selected=$(
            {
                printf ".\n"
                fd --type d --hidden --exclude .git 
            } | fzf --prompt="Directory > "
        ) || exit 1


        cd "$selected" || exit 1
        printf "%s\n" "$PWD" > "$2"
    ' sh "$start" "$out"

elif [ "$multiple" = 1 ]; then 

    "$termcmd" sh -c '
        cd "$1" || exit 1

        fd --type f --hidden --exclude .git | \
        fzf --multi --prompt="Files > " | \
        while IFS= read -r selected 
        do
            printf "%s/%s\n" "$PWD" "$selected"
        done > "$2"
    ' sh "$start" "$out"

else

    "$termcmd" sh -c '
        
        selected=$(
            fd --type f --hidden --exclude .git |
            fzf --prompt="File > "
        ) || exit 1

        printf "%s/%s\n" "$PWD" "$selected" > "$2"
    ' sh "$start" "$out"

fi
EOF

chmod +x $CONFIG/fzf-wrapper.sh

