FROM scratch
MAINTAINER Josh Wood <j@joshix.com>
COPY rootfs /
EXPOSE 2015
USER  22015
WORKDIR /var/www/html
CMD ["/bin/caddy"]
