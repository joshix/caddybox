FROM scratch
MAINTAINER Josh Wood <j@joshix.com>
COPY root /
WORKDIR /var/www/html
EXPOSE 2015
USER caddy
CMD ["/bin/caddy"]
