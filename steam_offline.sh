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
sudo ip net exec steam sudo -u steam /bin/bash -c ~steam/in_steam.sh
sudo ip net exec steam ip link delete steam_in
sudo ip net delete steam
sudo pkill -9 -u steam

