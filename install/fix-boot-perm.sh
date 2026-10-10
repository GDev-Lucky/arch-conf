#!/bin/bash

cp -f /etc/fstab /etc/fstab.before.boot-perm-fix
echo -e Backed up /etc/fstab to /etc/fstab.before.boot-perm-fix

sed -i '/[[:space:]]\/boot[[:space:]]/ s/fmask=0022,dmask=0022/umask=0077/' /etc/fstab
echo -e -e Updated /etc/fstab \\n \\n \\n

echo -e ===== VERIFY =====
grep -n '[[:space:]]/boot[[:space:]]' /etc/fstab | less

echo -e -e \\n \\n
mount -o remount /boot
echo -e Remounted /boot
echo -e -e \\n \\n

echo -e ===== FINAL OUT =====
findmnt -no OPTIONS /boot
echo -e \\n
stat -c "%a %n" /boot /boot/loader/random-seed
