#!/bin/bash

BOOT=$1
ROOT=$2

mkfs.fat -F 32 $BOOT
mkfs.ext4 $ROOT

mkdir -p /mnt
mount $ROOT /mnt

mkdir -p /mnt/boot
mount $BOOT /mnt/boot

echo ===== LINUX ROOT =====
findmnt /mnt

echo -e \\n \\n

echo ===== BOOT =====
findmnt /mnt/boot

echo -e \\n \\n

echo Successfully formatted partitions
