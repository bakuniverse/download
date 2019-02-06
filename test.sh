#!/bin/bash
cores=$(cat /proc/cpuinfo | grep 'model name'| wc -l)
cname=$( cat /proc/cpuinfo | grep 'model name' | uniq | awk -F : '{print $2}')
tram=$( free -m | awk '/Mem/ {print $2}' )
swap=$( free -m | awk '/Swap/ {print $2}' )

#检测版本6还是7
if  [ -n "$(grep ' 7\.' /etc/redhat-release)" ] ;then
CentOS_RHEL_version=7
elif
[ -n "$(grep ' 6\.' /etc/redhat-release)" ]; then
CentOS_RHEL_version=6
elif cat /proc/version | grep -Eqi "debian"; then
CentOS_RHEL_version=debian
fi

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

#清屏
clear

next
echo "Total amount of Mem  : $tram MB"
echo "Total amount of Swap : $swap MB"
echo "CPU model            : $cname"
echo "Number of cores      : $cores"
next

if [ "$CentOS_RHEL_version" -eq 6 ];then
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -ivh http://soft.paozailushang.com/vps/kernel-firmware-2.6.32-504.3.3.el6.noarch.rpm
rpm -ivh http://soft.paozailushang.com/vps/kernel-2.6.32-504.3.3.el6.x86_64.rpm --force
number=$(cat /boot/grub/grub.conf | awk '$1=="title" {print i++ " : " $NF}'|grep '2.6.32-504'|awk '{print $1}')
sed -i "s/^default=.*/default=$number/g" /etc/grub.conf
echo -e "\033[41;36m  5s later will reboot your server  \033[0m";
sleep 5
reboot
elif [ "$CentOS_RHEL_version" -eq 7 ];then
rpm -ivh http://soft.paozailushang.com/vps/kernel-3.10.0-229.1.2.el7.x86_64.rpm --force
grub2-set-default `awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | grep '(3.10.0-229.1.2.el7.x86_64) 7 (Core)'|awk '{print $1}'`
echo -e "\033[41;36m  5s later will reboot your server  \033[0m";
sleep 5
reboot
else
wget --no-check-certificate http://security-cdn.debian.org/pool/updates/main/l/linux/linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb
dpkg -i linux-image-3.16.0-4*.deb
apt-get -y remove linux-image-3.16.0-5-amd64
apt-get -y remove linux-image-3.16.0-6-amd64
apt-get -y remove linux-image-3.16.0-7-amd64
apt-get -y remove linux-image-3.16.0-8-amd64
apt-get -y remove linux-image-3.16.0-9-amd64
update-grub
echo -e "\033[41;36m  5s later will reboot your server  \033[0m";
sleep 5
reboot
fi

