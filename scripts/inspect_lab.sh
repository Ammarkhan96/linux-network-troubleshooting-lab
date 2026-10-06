#!/bin/bash

set -e

echo "=========================================="
echo " NETWORK NAMESPACE STATUS"
echo "=========================================="

echo
echo "--- Namespaces ---"
sudo ip netns list

echo
echo "--- ns1 interfaces ---"
sudo ip netns exec ns1 ip -br addr

echo
echo "--- ns1 routes ---"
sudo ip netns exec ns1 ip route

echo
echo "--- ns1 neighbors ---"
sudo ip netns exec ns1 ip neigh

echo
echo "--- ns-router interfaces ---"
sudo ip netns exec ns-router ip -br addr

echo
echo "--- ns-router routes ---"
sudo ip netns exec ns-router ip route

echo
echo "--- IP forwarding ---"
sudo ip netns exec ns-router sysctl net.ipv4.ip_forward

echo
echo "--- ns2 interfaces ---"
sudo ip netns exec ns2 ip -br addr

echo
echo "--- ns2 routes ---"
sudo ip netns exec ns2 ip route

echo
echo "--- ns2 neighbors ---"
sudo ip netns exec ns2 ip neigh

echo
echo "=========================================="
echo " CONNECTIVITY"
echo "=========================================="

echo
echo "ns1 -> router:"
sudo ip netns exec ns1 ping -c 2 10.10.1.254

echo
echo "ns2 -> router:"
sudo ip netns exec ns2 ping -c 2 10.10.2.254

echo
echo "ns1 -> ns2:"
sudo ip netns exec ns1 ping -c 3 10.10.2.1

echo
echo "ns2 -> ns1:"
sudo ip netns exec ns2 ping -c 3 10.10.1.1

echo
echo "=========================================="
echo " LAB HEALTH CHECK PASSED"
echo "=========================================="
