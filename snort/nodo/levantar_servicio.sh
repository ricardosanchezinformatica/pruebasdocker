#!/bin/sh
#parametros: $1-> servicio $2-> puerto
SERVIDOR=$(hostname)
ncat -l $2 -k -c "echo bienvenido al servicio $1;xargs -n1 echo $SERVIDOR: " &
