#!/usr/bin/env bash

root_install() {
    pacman -Syu --needed slurp grim
}

export -f root_install

su root -c 'root_install'

BIN=$HOME/.local/bin/screenshot
DIR=$HOME/pictures/screenshots

touch $BIN
mkdir -p $DIR

cat > $BIN <<'EOF'
#!/usr/bin/env bash

geometry="$(slurp)"

if [[ $1 == save ]]; then
    file="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
    grim -g "$geometry" "$file"
    wl-copy --type image/png $file
else
    grim -g "$geometry" - | wl-copy --type image/png
fi
    
EOF

sed -i "1a\DIR=$DIR" $BIN

chmod u+x $BIN






