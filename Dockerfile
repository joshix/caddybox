FROM golang:1.24 AS builder
RUN mkdir /build
WORKDIR /build
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.4
RUN xcaddy build v2.9.1

FROM scratch
LABEL maintainer="Josh Wood <j@joshix.com>"
LABEL caddy-version="2.9.1"
COPY rootfs /
COPY --from=builder /build/caddy /bin/caddy
USER 65534:65534
EXPOSE 8080
WORKDIR /var/www/html
ENTRYPOINT ["/bin/caddy"]
CMD ["run"]
