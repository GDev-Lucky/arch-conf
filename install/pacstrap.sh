#!/bin/bash

cpu=$1
gpu=$2
pack_conf=$3

pacstrap -C $pack_conf -K /mnt \
base \
linux \
less \
mkinitcpio \
e2fsprogs \
dosfstools \
"${cpu}-ucode" \
"linux-firmware-${gpu}" \
linux-firmware-realtek

cp $pack_conf /mnt/etc/pacman.conf
genfstab -U /mnt >> /mnt/etc/fstab

cat /mnt/etc/fstab | less

arch-chroot /mnt
