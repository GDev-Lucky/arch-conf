#!/bin/bash

echo ===== NETWORKCTL ======
networkctl status
echo -e \\n \\n \\n

echo ===== RESOLVECTL =====
resolvectl status
echo -e \\n \\n \\n

echo ===== IP =====
ip addr
ip route
echo -e \\n \\n \\n

echo ===== SOCKET =====
ss -tuln
echo -e \\n \\n \\n

echo ===== PING TEST =====
ping -c 3 archlinux.org
echo -e \\n \\n \\n

echo NETWORK TEST DONE!
