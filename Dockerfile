FROM golang:1.19.5 AS builder
RUN mkdir /build
WORKDIR /build
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.3.1
RUN GOOS=linux GOARCH=amd64 xcaddy build v2.6.2

FROM scratch
LABEL maintainer="Josh Wood <j@joshix.com>"
LABEL caddy_version="2.6.2"
COPY rootfs /
COPY --from=builder /build/caddy /bin/caddy
USER 65534:65534
EXPOSE 8080
WORKDIR /var/www/html
ENTRYPOINT ["/bin/caddy"]
CMD ["run"]
