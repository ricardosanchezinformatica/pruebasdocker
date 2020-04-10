FROM alpine

RUN apk add iptables

COPY red_firewall.sh /scripts/
COPY cambiar_router.sh /scripts/

#sshd copiado de https://github.com/sickp/docker-alpine-sshd/blob/master/versions/7.5-r2/Dockerfile
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY rootfs /

RUN apk add --no-cache openssh \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd

