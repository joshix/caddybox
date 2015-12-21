FROM scratch
MAINTAINER Josh Wood <j@joshix.com>
COPY rootfs /
EXPOSE 80 443 2015
WORKDIR /var/www/html
CMD ["/bin/caddy"]
