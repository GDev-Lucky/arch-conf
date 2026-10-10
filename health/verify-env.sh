#!/bin/bash

echo ===== UEFI-ENABLED =====
test -d /sys/firmware/efi/efivars && echo UEFI || echo NOT-UEFI
echo -e \\n \\n \\n

echo ===== TIME AND DATE =====
timedatectl
echo -e \\n \\n \\n

echo ===== DISK =====
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINTS,MODEL
echo -e \\n \\n \\n

echo ===== HARDWARE =====
lspci -nn
echo -e \\n \\n \\n

echo ===== NETWORK =====
ip -br link

echo -e \\n
ping -c 3 archlinux.org
echo -e \\n \\n \\n
