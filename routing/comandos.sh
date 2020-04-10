#!/bin/bash -x 
#busybox: su router por defecto será el firewall (que por lo tanto podrá ltrar paquetes)
docker exec --privileged -it pcadmin ip route del default
docker exec --privileged -it pcadmin route add default gw firewall eth0

#servers: instalar route (necesario para cambiar router por defecto), instalar ping, cambiar router por defecto
docker exec --privileged -it servermysql apt update
docker exec --privileged -it servermysql apt install -y net-tools
docker exec --privileged -it servermysql apt install -y iputils-ping
docker exec --privileged -it servermysql route delete default
docker exec --privileged -it servermysql route add default gw firewall eth0

#firewall: añadimos iptables
docker exec --privileged -it firewall apk add iptables
GATEWAY_INTERNET=$(docker inspect --format='{{(index .IPAM.Config 0).Gateway}}' routing_internet)
docker exec --privileged -it firewall ip route del default
#ojo aquí: asumo que la tajeta es eth2 (porque es la última red que defino en el docker-compose)
docker exec --privileged -it firewall route add default gw $GATEWAY_INTERNET eth2
IP_SALIDA_INTERNET=$(docker inspect --format='{{.NetworkSettings.Networks.routing_internet.IPAddress}}' firewall)
docker exec --privileged -it firewall iptables -t nat -A POSTROUTING -o eth2 -j SNAT --to $IP_SALIDA_INTERNET

#añadimos los nombres al etc/hoss para poder trabajar con nombres
LINEA_PCADMIN=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} pcadmin' pcadmin)
LINEA_SERVERMYSQL=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} servermysql' servermysql)
docker exec --privileged -it servermysql /bin/bash -c "echo $LINEA_PCADMIN >> /etc/hosts"
docker exec --privileged -it pcadmin /bin/sh -c "echo $LINEA_SERVERMYSQL >> /etc/hosts"

#abrir la ventana en la que el alumno tendrá que escribir sus reglas
docker exec --privileged -it firewall /bin/sh
