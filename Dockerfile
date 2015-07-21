FROM centurylink/ca-certs
MAINTAINER Josh Wood <j@joshix.com>
COPY root /
EXPOSE 2015
USER caddy
WORKDIR /var/www/html
CMD ["/bin/caddy"]
