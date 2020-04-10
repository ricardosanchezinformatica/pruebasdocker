#!/bin/bash -x 

#equipos normales: cambiamos el router por defecto
docker exec --privileged -it atacante /scripts/cambiar_router.sh firewall
docker exec --privileged -it servidor /scripts/cambiar_router.sh firewall

#equipos normales: levantamos servicios (ojo que no se pone el -it)
docker exec --privileged servidor /scripts/levantar_servicio.sh mysql 3306

#listamos contenedores
../listar_contenedores.sh
