#!/bin/bash

echo "Cleaning Linux Network Troubleshooting Lab..."

sudo ip netns del ns1 2>/dev/null || true
sudo ip netns del ns2 2>/dev/null || true
sudo ip netns del ns-router 2>/dev/null || true

echo
echo "Lab cleaned successfully."

echo
echo "Remaining namespaces:"
sudo ip netns list
