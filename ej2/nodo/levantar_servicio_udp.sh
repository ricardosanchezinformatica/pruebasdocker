#!/bin/sh
#parametros: $1-> servicio $2-> puerto
SERVIDOR=$(hostname)
ncat -c "echo bienvenido al servicio $1 del servidor $SERVIDOR" -k -u -l $puerto &
