FROM scratch
LABEL maintainer="Josh Wood <j@joshix.com>"
LABEL caddy_version="2.4.6"
COPY rootfs /
USER 65534:65534
EXPOSE 8080
WORKDIR /var/www/html
ENTRYPOINT ["/bin/caddy"]
CMD ["run"]
