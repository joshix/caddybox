FROM alpine
MAINTAINER Josh Wood <j@joshix.com>
COPY rootfs /
RUN apk update && apk add libcap && \
rm -rf /var/cache/apk/* && \
/usr/sbin/setcap cap_net_bind_service=+ep /caddy/caddy
USER 22015
EXPOSE 2015
WORKDIR /var/www/html
CMD ["/caddy/caddy"]
