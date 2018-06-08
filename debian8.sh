#!/bin/bash
wget --no-check-certificate http://security-cdn.debian.org/pool/updates/main/l/linux/linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb
dpkg -i linux-image-3.16.0-4*.deb
apt-get -y remove linux-image-3.16.0-5-amd64
apt-get -y remove linux-image-3.16.0-6-amd64
update-grub
echo -e "\033[41;36m  5s later will reboot your server  \033[0m";
sleep 5
reboot
