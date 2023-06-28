FROM golang:1.20 AS builder
RUN mkdir /build
WORKDIR /build
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.3.4
RUN xcaddy build v2.7.0-beta.2

FROM scratch
LABEL maintainer="Josh Wood <j@joshix.com>"
LABEL caddy-version="2.7.0-beta.2"
COPY rootfs /
COPY --from=builder /build/caddy /bin/caddy
USER 65534:65534
EXPOSE 8080
WORKDIR /var/www/html
ENTRYPOINT ["/bin/caddy"]
CMD ["run"]
