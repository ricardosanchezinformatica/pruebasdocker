#!/bin/bash -x 

#equipos normales: cambiamos el router por defecto
docker exec --privileged -it pcadmin /scripts/cambiar_router.sh firewall
docker exec --privileged -it servermysql /scripts/cambiar_router.sh firewall

#equipos normales: levantamos servicios (ojo que no se pone el -it)
docker exec --privileged servermysql /scripts/levantar_servicio.sh mysql 3306

#firewall: ajustes de red
GATEWAY_INTERNET=$(docker inspect --format='{{(index .IPAM.Config 0).Gateway}}' ${PWD##*/}_internet)
IP_SALIDA_INTERNET=$(docker inspect --format="{{.NetworkSettings.Networks.${PWD##*/}_internet.IPAddress}}" firewall)
#ojo que asumo que la tarjeta es eth2 porque defino 3 interfaces en docker-compose y la última que defino esinternet 
docker exec --privileged -it firewall /scripts/red_firewall.sh eth2 $GATEWAY_INTERNET $IP_SALIDA_INTERNET

#listamos contenedores
../listar_contenedores.sh
