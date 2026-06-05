FROM golang:1.26 AS builder
RUN mkdir /build
WORKDIR /build
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.5
RUN xcaddy build v2.11.4

FROM scratch
LABEL maintainer="Josh Wood <j@joshix.com>"
LABEL caddy-version="2.11.4"
COPY rootfs /
COPY --from=builder /build/caddy /bin/caddy
USER 65534:65534
EXPOSE 8080
WORKDIR /var/www/html
ENTRYPOINT ["/bin/caddy"]
CMD ["run"]
