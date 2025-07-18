# Caddy container image

[![Container Image on Quay](https://quay.io/repository/joshix/caddy/status "Container Image on Quay")][quay-joshix-caddy]

This container image encapsulates a [*Caddy*][caddy] HTTP server. It is built `FROM` the [*scratch* image][scratchimg] and executes a statically-linked `caddy` binary with no added [modules][caddons]. It includes a tiny `index.html` landing page so that it can be demonstrated without configuration on any container host by invoking e.g., `docker run -d -P quay.io/joshix/caddy`.

By default this caddy listens on the container's `EXPOSE`d TCP port #8080 and attempts to fulfill requests with files beneath the container's `/var/www/html/`.

Content should be added by binding a host volume over that path, or by `COPY`ing/`ADD`ing files there when building an image `FROM` this one. Adding a `Caddyfile` through the same mechanisms allows configuration of the web server and sites as described in the [Caddy documentation][caddydocs].

## Container File System

The caddy binary produced by the build stage and the file tree beneath `./rootfs/` are `COPY`'d to the container's `/`, resulting in this file hierarchy in the container image:

* `/bin/caddy` - Server executable and container `ENTRYPOINT`
* `/var/www/html/` - Caddy working directory and root of HTTP name space
* `/var/www/html/Caddyfile` - Default configuration
* `/var/www/html/index.html` - Default landing page

## Adding Content

There are at least two ways to provide Caddy with content and configuration.

* Bind a host file system path over the container's HTTP name space root:

```sh
$ ls site/html
  index.html
  [...]
$ docker run -d -p 8080:8080 -v ./site:/var/www:ro quay.io/joshix/caddy
```

OR,

* Build the files into an image based on this one:

```sh
$ cd site/html
$ ls
  Dockerfile
  index.html
  [...]
$ cat Dockerfile
  FROM quay.io/joshix/caddy
  COPY . /var/www/html
$ docker build -t "com.mysite-caddy" .
$ docker run -d -p 8080:8080 com.mysite-caddy
```

## Configuration

To configure Caddy, add `Caddyfile` to the server's working directory:

```sh
$ ls site/html
  Caddyfile
  index.md
  [...]
$ cat site/html/Caddyfile
  :8080 {
    file_server {
    }
    log {
      output stdout
    }
  }
  [...]
$ docker run -d -p 8080:8080 -v ./site:/var/www:ro quay.io/joshix/caddy
```

### Manual TLS

To serve HTTPS, add certificate and key files, with a Caddyfile naming them:

```sh
$ ls site
  html/
  tls/
$ ls site/html
  Caddyfile
  index.html
  [...]
$ ls site/tls
  site.crt
  site.key
$ cat site/html/Caddyfile
  {
    http_port 8080
  }
  :8443 {
    tls ../tls/site.crt ../tls/site.key
    file_server {
    }
    log {
      output stdout
    }
  }
  [...]
$ docker run -d -p 8080:8080 -p 8443:8443 -v ./site:/var/www:ro quay.io/joshix/caddy
```

### Automatic *Let's Encrypt* TLS

Caddy can [automatically acquire and renew TLS keys and certificates][caddyautotls] to secure connections using the *Let's Encrypt* project's ACME protocol. Because this container runs the `caddy` executable as an unprivileged user, it cannot bind privileged ports (port numbers < 1024) without further arrangement. This container is intended for use behind a container network like that provided by Docker or the Kubernetes CNI. Usually TLS termination happens at the edge of the container host network rather than at the HTTPd.

## Cloning this repo

Versions up to v2.6.2-cb.1 included a caddy binary built outside the container build process. While that is no longer true, and caddy is built in a multi-stage container build, this repo remains large with every previous version having a binary at `rootfs/bin/caddy`.

Work around this with git's shallow clone. This fetches only the given number of revisions. For most new clones of this repo, that number should be 1. Something like `git clone --depth 1 https://github.com/joshix/caddybox` should require only a small download and disk allocation.

## Building Caddy with xcaddy

Preserved for reference. The build is no longer done out-of-band and the caddy binary is no longer included in this container image source repo. Instead, the xcaddy build tool runs inside a first stage build container in a [multi-stage][multi-stage-build] [Dockerfile][Dockerfile].

<https://github.com/caddyserver/xcaddy>

```sh
cd /tmp/caddyboxbuild
GOOS=linux GOARCH=amd64 xcaddy build v2.10.0
file caddy
cp caddy [...]/caddybox/rootfs/bin/caddy
```

[caddons]: https://caddyserver.com/docs/modules/
[caddy]: https://caddyserver.com
[caddyautotls]: https://caddyserver.com/docs/automatic-https
[caddydocs]: https://caddyserver.com/docs
[Dockerfile]: Dockerfile
[multi-stage-build]: https://docs.docker.com/build/building/multi-stage/
[quay-joshix-caddy]: https://quay.io/repository/joshix/caddy
[scratchimg]: https://hub.docker.com/_/scratch/
