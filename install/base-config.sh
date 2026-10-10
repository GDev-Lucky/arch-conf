#!/bin/bash

timezone=$1
lang=$2
host=$3

echo -e \\n \\n
ln -sf "/usr/share/zoneinfo/${timezone}" /etc/localtime
hwclock --systohc
echo -e TIMEZONE=$timezone \\n \\n
 
sed -i 's/^"#${lang} UTF-8"/"${lang} UTF-8"/' /etc/locale.gen
locale-gen
printf '%s\n' "LANG=${lang}" > /etc/locale.conf
echo -e LANG= $lang \\n \\n

printf '%s\n' $host > /etc/hostname
passwd
echo -e \\n \\n
echo -e HOST=$host
