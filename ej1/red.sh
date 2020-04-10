#!/bin/bash -x 

#en la dmz he hecho un script individual porque tiene dos routers y tres rutas
docker exec --privileged -it neptune /scripts/cambiar_router.sh firewall
docker exec --privileged -it bender /scripts/cambiar_router.sh firewall
docker exec --privileged -it uranus /scripts/cambiar_router.sh firewall
docker exec --privileged -it smtp /scripts/cambiar_router.sh firewall
docker exec --privileged -it sparc /scripts/cambiar_router.sh firewall
docker exec --privileged -it backup /scripts/cambiar_router.sh firewall

docker exec --privileged -it pc1 /scripts/cambiar_router.sh firewall
docker exec --privileged -it pc2 /scripts/cambiar_router.sh firewall


#firewall: ajustes de red varios
GATEWAY_INTERNET=$(docker inspect --format='{{(index .IPAM.Config 0).Gateway}}' ${PWD##*/}_internet)
IP_SALIDA_INTERNET=$(docker inspect --format="{{.NetworkSettings.Networks.${PWD##*/}_internet.IPAddress}}" firewall)
#ojo que asumo que la tarjeta es eth2 porque defino 3 interfaces en docker-compose y la última que defino es internet 
docker exec --privileged -it firewall /scripts/red_firewall.sh eth2 $GATEWAY_INTERNET $IP_SALIDA_INTERNET


#levantamos servicios (ojo que no se pone el -it)
docker exec --privileged neptune /scripts/levantar_servicio_udp.sh dns 53
docker exec --privileged neptune /scripts/levantar_servicio_udp.sh dhcp 67
docker exec --privileged neptune /scripts/levantar_servicio.sh proxy 3031

docker exec --privileged bender /scripts/levantar_servicio_udp.sh dns 53
docker exec --privileged bender /scripts/levantar_servicio_udp.sh dhcp 67
docker exec --privileged bender /scripts/levantar_servicio.sh proxy 3031

docker exec --privileged uranus /scripts/levantar_servicio.sh http 80
docker exec --privileged uranus /scripts/levantar_servicio.sh https 443
docker exec --privileged uranus /scripts/levantar_servicio.sh ftp 21
#ftp está mal planteado, pero bueno
docker exec --privileged uranus /scripts/levantar_servicio.sh ftp-data 20

docker exec --privileged smtp /scripts/levantar_servicio.sh smtp 25
docker exec --privileged smtp /scripts/levantar_servicio.sh https 443
docker exec --privileged smtp /scripts/levantar_servicio.sh pop 110
docker exec --privileged smtp /scripts/levantar_servicio.sh imap 143

docker exec --privileged sparc /scripts/levantar_servicio.sh http 80
docker exec --privileged sparc /scripts/levantar_servicio.sh https 443
docker exec --privileged sparc /scripts/levantar_servicio.sh ftp 21
#ftp está mal planteado, pero bueno
docker exec --privileged sparc /scripts/levantar_servicio.sh ftp-data 20

#listamos contenedores
../listar_contenedores.sh
