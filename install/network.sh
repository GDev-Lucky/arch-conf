#!/bin/bash

mkdir -p /etc/systemd/network

#!/bin/bash

network_dir=/etc/systemd/network

mkdir -p $network_dir
echo Created network dir @ $network_dir
 

[Match]
Name=en*

[Network]
DHCP=yes
EOF

echo Created wired network config


ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
echo Linked system stub-resolv.conf to /etc/resolv.conf

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable systemd-timesyncd.service
echo Started systemd\'s  network, dns and timesync
