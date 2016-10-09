#!/bin/bash
set -v
token=`uuid`
sudo ip net exec steam ip link del dev tun99
sudo ssh -o Tunnel=ethernet -v -F ~/.ssh/config -i /home/steam/.ssh/id_rsa -f -N -w 99:99 root@vpn $token
sudo ip link set netns steam dev tap99
sudo ip net exec steam ip link set up dev tap99
sudo ip net exec steam ip link set mtu 1452 dev tap99
sudo ip net exec steam ip a a 100.99.64.2/24 dev tap99
sudo ip net exec steam ip route add default via 100.99.64.1
