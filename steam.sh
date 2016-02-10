#!/bin/bash
set -v
pacmd load-module module-native-protocol-tcp auth-anonymous=1
xhost +local:steam
token=`uuid`
sudo ip netns add steam
sudo ip link add name steam_in type veth peer name steam_out
sudo ip link set netns steam dev steam_in
sudo ip link set up dev steam_out
sudo ip net exec steam ip link set up dev steam_in
sudo ip net exec steam ip a a 10.6.0.1/24 dev steam_in
sudo ip a a 10.6.0.2/24 dev steam_out
sudo ip net exec steam ip link set up dev lo
sudo ssh -o Tunnel=ethernet -v -F ~/.ssh/config -i /home/steam/.ssh/id_rsa -f -N -w 99:99 root@vpn $token
sudo ip link set netns steam dev tap99
sudo ip net exec steam ip link set up dev tap99
sudo ip net exec steam ip link set mtu 1452 dev tap99
sudo ip net exec steam ip a a 100.99.64.2/24 dev tap99
sudo ip net exec steam ip route add default via 100.99.64.1

echo 'nameserver 8.8.8.8' |sudo tee /etc/resolv.conf >/dev/null
#sudo ip net exec steam /bin/bash
#sudo ip net exec steam login -f steam
sudo ip net exec steam sudo -u steam /bin/bash -c ~steam/in_steam.sh
#sudo ip net exec steam sudo login -f steam
sudo ip net exec steam ip link delete steam_in
sudo ip net delete steam
sudo pgrep -f $token|sudo xargs kill -9
sudo pkill -9 -u steam
