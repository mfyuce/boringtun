

sudo ./create_namespace.sh
sudo ip netns exec right bash
sudo WG_QUICK_USERSPACE_IMPLEMENTATION=./target/release/boringtun-cli WG_SUDO=1 wg-quick up  ./wg1.conf
sudo WG_QUICK_USERSPACE_IMPLEMENTATION=../wireguard-go/wireguard-go WG_SUDO=1 wg-quick up  ./wg1.conf

sudo ip netns exec right sudo WG_QUICK_USERSPACE_IMPLEMENTATION=./target/release/boringtun-cli WG_SUDO=1 wg-quick up  ./wg1.conf
sudo ip netns exec right sudo WG_QUICK_USERSPACE_IMPLEMENTATION=../wireguard-go/wireguard-go WG_SUDO=1 wg-quick up  ./wg1.conf



sudo ip netns exec left bash
sudo ip netns exec left sudo  WG_QUICK_USERSPACE_IMPLEMENTATION=./target/release/boringtun-cli WG_SUDO=1 wg-quick up  ./wg0.conf
sudo ip netns exec left sudo  WG_QUICK_USERSPACE_IMPLEMENTATION=../wireguard-go/wireguard-go WG_SUDO=1 wg-quick up  ./wg0.conf
sudo WG_QUICK_USERSPACE_IMPLEMENTATION=../wireguard-go/wireguard-go WG_SUDO=1 wg-quick up  ./wg0.conf

sudo ip netns exec left ip route add default dev wg0
sudo ip netns exec right ip route add default dev wg1
sudo ip netns exec midle ip route add default dev wg2


sudo ip netns exec left  ip link add dum0 type dummy
sudo ip netns exec left ip a
sudo ip netns exec right  ip link add dum0 type dummy
sudo ip netns exec left ip addr add 10.10.10.10/24 dev dum0
sudo ip netns exec right ip addr add 10.20.20.10/24 dev dum0
sudo ip netns exec right ip link set up dev dum0
sudo ip netns exec left ip link set up dev dum0




sudo ip netns exec left iperf3 -s -B 10.10.10.10
sudo ip netns exec right iperf3 -c 10.10.10.10 -B 10.20.20.10 -t 1000 -P 100


sudo ip netns exec wg-test-30817-2 ethtool --show-offload wg2





onetun 127.0.0.1:5201:10.10.10.10:5201     \
--endpoint-addr 172.16.16.10:51820         \
--endpoint-public-key xF9WVWXRKYDPoDWBvwzqMb04QqWNOhFvzgerBAxdGio=    \
--private-key IHlvp0+qVAiCcITXpgUsoJYcmCEdRyO29OaP59UPB2E=                   \
--source-peer-ip 192.168.2.1/24                              \
--keep-alive <optional persistent keep-alive in seconds>              \
--log <optional log level, defaults to "info">






sudo ip netns exec left sudo  WG_QUICK_USERSPACE_IMPLEMENTATION=../wireguard-go/wireguard-go WG_SUDO=1 wg-quick up  ./wg2.conf