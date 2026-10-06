#!/bin/bash

set -euo pipefail

echo "=========================================="
echo " Linux Network Troubleshooting Lab"
echo "=========================================="

echo "[1/8] Cleaning old lab..."
sudo ip netns del ns1 2>/dev/null || true
sudo ip netns del ns2 2>/dev/null || true
sudo ip netns del ns-router 2>/dev/null || true

echo "[2/8] Creating network namespaces..."
sudo ip netns add ns1
sudo ip netns add ns2
sudo ip netns add ns-router

echo "[3/8] Creating veth pairs..."
sudo ip link add veth1 type veth peer name veth1-rtr
sudo ip link add veth2 type veth peer name veth2-rtr

echo "[4/8] Moving interfaces into namespaces..."
sudo ip link set veth1 netns ns1
sudo ip link set veth1-rtr netns ns-router

sudo ip link set veth2 netns ns2
sudo ip link set veth2-rtr netns ns-router

echo "[5/8] Configuring ns1..."
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip link set veth1 up
sudo ip netns exec ns1 ip addr add 10.10.1.1/24 dev veth1

echo "[6/8] Configuring ns2..."
sudo ip netns exec ns2 ip link set lo up
sudo ip netns exec ns2 ip link set veth2 up
sudo ip netns exec ns2 ip addr add 10.10.2.1/24 dev veth2

echo "[7/8] Configuring router..."
sudo ip netns exec ns-router ip link set lo up

sudo ip netns exec ns-router ip link set veth1-rtr up
sudo ip netns exec ns-router ip addr add 10.10.1.254/24 dev veth1-rtr

sudo ip netns exec ns-router ip link set veth2-rtr up
sudo ip netns exec ns-router ip addr add 10.10.2.254/24 dev veth2-rtr

echo "[8/8] Enabling IP forwarding..."
sudo ip netns exec ns-router sysctl -w net.ipv4.ip_forward=1

echo "Adding routes..."

sudo ip netns exec ns1 ip route add 10.10.2.0/24 via 10.10.1.254

sudo ip netns exec ns2 ip route add 10.10.1.0/24 via 10.10.2.254

echo
echo "=========================================="
echo " Lab created successfully!"
echo "=========================================="

echo
echo "Namespaces:"
sudo ip netns list

echo
echo "ns1:"
sudo ip netns exec ns1 ip addr

echo
echo "ns-router:"
sudo ip netns exec ns-router ip addr

echo
echo "ns2:"
sudo ip netns exec ns2 ip addr

echo
echo "Routes:"
sudo ip netns exec ns1 ip route
sudo ip netns exec ns-router ip route
sudo ip netns exec ns2 ip route

echo
echo "Testing connectivity..."

sudo ip netns exec ns1 ping -c 2 10.10.1.254
sudo ip netns exec ns2 ping -c 2 10.10.2.254
sudo ip netns exec ns1 ping -c 3 10.10.2.1
sudo ip netns exec ns2 ping -c 3 10.10.1.1

echo
echo "=========================================="
echo " Connectivity test completed!"
echo "=========================================="
