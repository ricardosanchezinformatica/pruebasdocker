#!/bin/sh

INTERFAZ_INTERNET=$1 #ej: eth2
GATEWAY_INTERNET=$2 #ej: 172.16.0.1 (gateway que levanta autom√ticamente docker en la red "internet") (el que se corresponde al propio turnkey core)
IP_FIREWALL_EN_RED_INTERNET=$3 #ej: 172.16.0.2 (la ip del propio nodo "firewall" en la red "internet")

#cambiar router por defecto para que use el de la red internet
ip route del default
route add default gw $GATEWAY_INTERNET $INTERFAZ_INTERNET

#habilitar NAT para lo que salga a trav√©s de la red internet
iptables -t nat -A POSTROUTING -o $INTERFAZ_INTERNET -j SNAT --to $IP_FIREWALL_EN_RED_INTERNET

