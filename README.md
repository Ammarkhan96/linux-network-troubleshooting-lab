# Linux Network Troubleshooting Lab

A hands-on Linux networking lab that builds isolated Linux hosts using network namespaces and veth pairs.

The lab contains two isolated hosts connected through a Linux router. It demonstrates IP addressing, routing, ARP/neighbour discovery, IP forwarding, connectivity testing, socket inspection, traceroute and packet capture with tcpdump.

## Architecture

```text
                    Linux Router
                   ns-router
              +--------------------+
              |                    |
       10.10.1.254/24      10.10.2.254/24
              |                    |
          veth1-rtr            veth2-rtr
              |                    |
            veth1                veth2
              |                    |
       +-------------+      +-------------+
       |     ns1     |      |     ns2     |
       | 10.10.1.1   |      | 10.10.2.1   |
       | App/Client  |      | App/Server  |
       +-------------+      +-------------+
