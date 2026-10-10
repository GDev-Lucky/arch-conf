#!/bin/bash

echo -e -e \\n \\n

echo -e -e ===== BASIC INFO =====
whoami
pwd
uname -a
cat /etc/os-release
echo -e -e \\n \\n \\n

echo -e -e ===== INSTALLED PACKAGES =====
pacman -Qe
echo -e -e \\n \\n \\n

echo -e -e ===== PACKAGE DEPENDENCIES =====
pacman -Qd
echo -e -e \\n \\n \\n

echo -e -e ===== SERVICES =====
systemctl --type=service --state=running
echo -e -e \\n \\n
systemctl list-unit-files --state=enabled
echo -e \\n \\n===FAILED SERVICES===
systemctl --failed
echo -e -e \\n \\n \\n

echo -e ==== RUNNING PROCESSES =====
ps aux
echo -e -e \\n \\n \\n

echo -e ===== STORAGE =====
lsblk -f
echo -e \\n \\n
findmnt
echo -e \\n \\n
df -h
echo -e \\n \\n
du -sh /
echo -e -e \\n \\n \\n

echo -e ===== HARDWARE =====
lspci -k
echo -e \\n \\n
lsmod
echo -e \\n \\n
dmesg | tail -n 100
echo -e -e \\n \\n \\n

echo -e ===== NETWORK =====
networkctl
echo -e \\n \\n
ip addr
echo -e \\n \\n
ip route
echo -e \\n \\n
ss -tulpn
resolvectl
echo -e -e \\n \\n \\n
 
 echo -e ===== TIME ===== 
 timedatectl 
 echo -e \\n \\n \\n

echo -e ===== JOURNAL =====
journalctl -b -p warning
