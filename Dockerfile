FROM alpine
MAINTAINER Josh Wood <j@joshix.com>
LABEL caddy_version="0.8"
COPY rootfs /
RUN apk update && apk add libcap && \
rm -rf /var/cache/apk/* && \
/usr/sbin/setcap cap_net_bind_service=+ep /usr/local/bin/caddy
USER 22015
EXPOSE 80
EXPOSE 443
EXPOSE 2015
WORKDIR /var/www/html
CMD ["/usr/local/bin/caddy"]
