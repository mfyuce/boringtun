
./create_namespace.sh
sudo ip netns exec right bash
sudo WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun-cli WG_SUDO=1 wg-quick up  ./wg1.conf

sudo ip netns exec left bash
sudo WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun-cli WG_SUDO=1 wg-quick up  ./wg0.conf



sudo ip netns exec left ip route add default dev wg0
sudo ip netns exec right ip route add default dev wg1




sudo ip netns exec left iperf3 -s -B 10.10.10.10
sudo ip netns exec right iperf3 -c 10.10.10.10 -B 10.20.20.10 -t 1000 -P 100


sudo ip netns exec wg-test-30817-2 ethtool --show-offload wg2

