#!/bin/bash
if [ $# -ne 1 ]; then
    echo "debe indicar el contenedor al que conectarse"
fi
echo "conectando a $1 ..."
docker exec -it $1 /bin/sh
