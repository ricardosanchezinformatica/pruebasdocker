#!/bin/bash -x 

#en la dmz he hecho un script individual porque tiene dos routers y tres rutas
docker exec --privileged -it luke /scripts/rutas_dmz.sh
docker exec --privileged -it anakin /scripts/rutas_dmz.sh
docker exec --privileged -it hansolo /scripts/rutas_dmz.sh
docker exec --privileged -it yoda /scripts/rutas_dmz.sh
docker exec --privileged -it chewbacca /scripts/rutas_dmz.sh

docker exec --privileged -it bacula /scripts/cambiar_router.sh fw2
docker exec --privileged -it pcadminitdesa /scripts/cambiar_router.sh fw2

docker exec --privileged -it pcuser1 /scripts/cambiar_router.sh fw2
docker exec --privileged -it pcuser2 /scripts/cambiar_router.sh fw2


#fw1: ajustes de red varios
GATEWAY_INTERNET=$(docker inspect --format='{{(index .IPAM.Config 0).Gateway}}' ${PWD##*/}_internet)
IP_SALIDA_INTERNET=$(docker inspect --format="{{.NetworkSettings.Networks.${PWD##*/}_internet.IPAddress}}" fw1)
#ojo que asumo que la tarjeta es eth1 porque defino 1 interfaces en docker-compose y la última que defino es internet 
docker exec --privileged -it fw1 /scripts/red_firewall.sh eth1 $GATEWAY_INTERNET $IP_SALIDA_INTERNET
docker exec --privileged -it fw1 route add -net 172.16.0.0 netmask 255.255.0.0 gw 192.168.0.100
docker exec --privileged -it fw1 route add -net 10.0.0.0 netmask 255.0.0.0 gw 192.168.0.100

#fw2 tiene menos cosa: como no tiene que hacer nat, le cambiamos el router por defecto y listos
docker exec --privileged -it fw2 /scripts/cambiar_router.sh fw1


#levantamos servicios (ojo que no se pone el -it)
docker exec --privileged luke /scripts/levantar_servicio.sh http 80
docker exec --privileged luke /scripts/levantar_servicio.sh https 443
docker exec --privileged luke /scripts/levantar_servicio.sh ftp 21
#todos sabemos que esto está mal, pero el ejercicio está mal planteado. Habría que preguntarse si el modo es activo o pasivo, y no sé cuál es peor en cuanto a puertos (activo: cliente debe admitir conexiones entrantes. Pasivo: las conexiones van de puerto desconocido a puerto desconocido, sólo se puede aproximar el rango)
docker exec --privileged luke /scripts/levantar_servicio.sh ftp-data 20
docker exec --privileged luke /scripts/levantar_servicio.sh webmin 10000

docker exec --privileged yoda /scripts/levantar_servicio_udp.sh dns 53
docker exec --privileged yoda /scripts/levantar_servicio.sh proxy 8080
docker exec --privileged yoda /scripts/levantar_servicio.sh webmin 10000

docker exec --privileged hansolo /scripts/levantar_servicio.sh http 80
docker exec --privileged hansolo /scripts/levantar_servicio.sh https 443
docker exec --privileged hansolo /scripts/levantar_servicio.sh ftp 21
#todos sabemos que esto está mal, pero el ejercicio está mal planteado. Habría que preguntarse si el modo es activo o pasivo, y no sé cuál es peor en cuanto a puertos (activo: cliente debe admitir conexiones entrantes. Pasivo: las conexiones van de puerto desconocido a puerto desconocido, sólo se puede aproximar el rango)
docker exec --privileged hansolo /scripts/levantar_servicio.sh ftp-data 20
docker exec --privileged hansolo /scripts/levantar_servicio.sh webmin 10000

docker exec --privileged anakin /scripts/levantar_servicio.sh http 80
docker exec --privileged anakin /scripts/levantar_servicio.sh ftp 21
#todos sabemos que esto está mal, pero el ejercicio está mal planteado. Habría que preguntarse si el modo es activo o pasivo, y no sé cuál es peor en cuanto a puertos (activo: cliente debe admitir conexiones entrantes. Pasivo: las conexiones van de puerto desconocido a puerto desconocido, sólo se puede aproximar el rango)
docker exec --privileged anakin /scripts/levantar_servicio.sh ftp-data 20
docker exec --privileged anakin /scripts/levantar_servicio.sh webmin 10000

docker exec --privileged chewbacca /scripts/levantar_servicio.sh svn 3690

#me falta levantar los servicios de bacula

#listamos contenedores
../listar_contenedores.sh
