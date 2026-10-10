#!/bin/bash

loader_dir="/boot/loader"
root_uuid=$(blkid -s UUID -o value $1)

bootctl install
echo -e Installed bootctl \\n \\n

mkdir -p $loader_dir/entries
cat > /boot/loader/loader.conf <<EOF
default arch.conf
timeout 2
editor no
EOF
echo -e Created loader config \\n \\n

cat > $loader_dir/entries/arch.conf << EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID=$root_uuid rw
EOF
echo -e Added Arch linux entry to loader

echo -e \\n \\n \\n===== BOOT SETUP VERIFICATION =====

echo === BOOT FILES ===
ls -lh /boot

echo -e \\n \\n

echo === BOOT CONFIG ===
bootctl list
