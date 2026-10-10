#!/bin/bash

failures=0
warnings=0

pass() { printf '[PASS] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; warnings=$((warnings + 1)); }
fail() { printf '[FAIL] %s\n' "$*"; failures=$((failures + 1)); }

echo ===== NETWORK HEALTH =====

if systemctl is-active --q systemd-networkd.service; then
   pass "systemd-networkd is active"
else
   fail "systemd-networkd is not active"
fi

if [[ -L /etc/resolv.conf ]]; then
   target="$(readlink /etc/resolv.conf)"
printf "resolv.conf -> %s
" "$target"
   if [[ "$target" == *systemd/resolve/stub-resolv.conf* ]]; then
      pass "/etc/resolv.conf uses resolved link"
   else
      warn "/etc/resolv.conf is a symlink, but not to resolved stub"
   fi
else
   fail "etc/resolv.conf is not a symlink"
fi
