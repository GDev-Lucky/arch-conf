#!/bin/bash

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
echo Linked stub-resolv.conf to  /etc/resolv.conf

echo -e \\n \\n=====STATUS=====
resolvectl status
echo -e \\n \\n

echo -e ===== TEST =====
getent hosts archlinux.org
echo -e \\n
ping -c 3 archlinux.org
