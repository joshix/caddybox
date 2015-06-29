FROM scratch
MAINTAINER Josh Wood <j@joshix.com>
COPY root /
EXPOSE 2015
WORKDIR /var/www/html
CMD ["/bin/caddy"]
