#!/bin/sh
route del default
route add default gw fw1 eth0
route add -net 172.16.0.0 netmask 255.255.0.0 gw 192.168.0.100
route add -net 10.0.0.0 netmask 255.0.0.0 gw 192.168.0.100
