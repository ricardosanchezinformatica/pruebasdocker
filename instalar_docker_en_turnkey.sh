#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Debes ejecutar este script como root" 
   exit 1
fi

apt-get update && \
apt-get install -y     apt-transport-https     ca-certificates     curl     gnupg2     software-properties-common && \
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
printf 'deb [arch=amd64] https://download.docker.com/linux/debian stretch stable\n' | tee /etc/apt/sources.list.d/docker-ce.list && \
apt-get update && \
apt-get install docker-ce docker-ce-cli containerd.io && \
docker run hello-world && \
curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose && \
echo TODO LISTO
