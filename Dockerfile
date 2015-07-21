FROM scratch
MAINTAINER Josh Wood <j@joshix.com>
COPY rootfs /
EXPOSE 2015
USER caddy
WORKDIR /var/www/html
CMD ["/bin/caddy"]
