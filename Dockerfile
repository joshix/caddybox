FROM alpine
MAINTAINER Josh Wood <j@joshix.com>
LABEL caddy_version="0.8"
COPY rootfs /
USER 22015
EXPOSE 80 443 2015
RUN apk update && apk add libcap && \
rm -rf /var/cache/apk/* && \
/usr/sbin/setcap cap_net_bind_service=+ep /usr/local/bin/caddy
WORKDIR /var/www/html
ENTRYPOINT ["/usr/local/bin/caddy"]
