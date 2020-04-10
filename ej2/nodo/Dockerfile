FROM alpine

RUN apk add busybox-extras
RUN apk add nmap-ncat

COPY cambiar_router.sh /scripts/
COPY levantar_servicio.sh /scripts/
COPY levantar_servicio_udp.sh /scripts/
COPY rutas_dmz.sh /scripts/

#sshd copiado de https://github.com/sickp/docker-alpine-sshd/blob/master/versions/7.5-r2/Dockerfile
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY rootfs /

RUN apk add --no-cache openssh \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd
