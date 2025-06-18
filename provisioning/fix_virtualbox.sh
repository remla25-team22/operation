#!/bin/bash
# chmod +x fix_virtualbox.sh

echo "Removing all existing VirtualBox host-only interfaces..."
for ifname in $(VBoxManage list hostonlyifs | grep '^Name:' | awk '{print $2}'); do
    echo "Removing $ifname..."
    VBoxManage hostonlyif remove "$ifname"
done

echo "Creating new host-only interface..."
VBoxManage hostonlyif create

echo "Configuring vboxnet0 with IP 192.168.56.1/24..."
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0

echo "Removing any associated DHCP servers..."
for dhcp in $(VBoxManage list dhcpservers | grep 'NetworkName:' | awk '{print $2}'); do
    echo "Removing DHCP server for $dhcp..."
    VBoxManage dhcpserver remove --ifname "$dhcp"
done

echo " Host-only network setup complete."
