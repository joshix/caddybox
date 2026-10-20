FROM golang:1.27 AS builder
RUN mkdir /build
WORKDIR /build
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.7
RUN xcaddy build v2.11.7

FROM scratch
LABEL maintainer="Josh Wood <j@joshix.com>"
LABEL caddy-version="2.11.7"
COPY rootfs /
COPY --from=builder /build/caddy /bin/caddy
EXPOSE 8080
WORKDIR /var/www/html
ENTRYPOINT ["/bin/caddy"]
CMD ["run"]
