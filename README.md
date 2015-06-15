# Caddy image for Docker

Without configuration, this Docker image encapsulates a
[*Caddy*](http://caddyserver.com) HTTP server for static files.
A `/bin/caddy` process listens on the container's `EXPOSE`d TCP
port #2015 and attempts to fulfill requests with files beneath
the container's `/var/www/html/`.

Content should be added by binding over that path with a host volume,
or by `COPY`ing/`ADD`ing files there when `docker build`ing a custom
image based on this one. Adding a `Caddyfile` through the same
mechanisms allows configuration.

## Container file system:
* `/bin/caddy` # Server executable
* `/etc/passwd` # UID to run server
* `/var/www/html/` # Server working directory and root of HTTP name space

## Adding Content

There are at least two ways to provide Caddy with content and configuration.

* Bind a host file system path over the container's HTTP name space root:

```
% ls /home/j/site
  index.html
  img/
  [...]
% docker run -d -p 8080:2015 -v /home/j/site:/var/www/html:ro joshix/caddy
```

OR,

* Build the files into an image based on this one:

```
% cd /home/j/site.build
% ls
  Dockerfile
  index.html
  img/logo.png
  [...]
% cat Dockerfile
  FROM joshix/caddy
  COPY . /var/www/html
% docker build -t "com.mysite-caddy" .
% docker run -d -p 8080:2015 com.mysite-caddy
```

## Configuration
To configure Caddy, add `Caddyfile` to the server's working directory:

```
% ls /home/j/site
  Caddyfile
  index.md
  img/
  [...]
% cat /home/j/site/Caddyfile
  0.0.0.0:2015
  ext .html .htm .md
  markdown /
  gzip
  [...]
% docker run -d -p 8080:2015 -v /home/j/site:/var/www/html:ro joshix/caddy
```

### TLS
To serve HTTPS, add certificate and key files, with a Caddyfile naming them:

```
% ls /home/j/site
  html/
  tls/
% ls /home/j/site/html
  Caddyfile
  index.html
  img/
  [...]
% ls /home/j/site/tls
  site.crt
  site.key
% cat /home/j/site/html/Caddyfile
  0.0.0.0:2015 {
    redir https://site.com # Redirect any HTTP req to HTTPS
  }
  0.0.0.0:2378 {
    tls ../tls/site.crt ../tls/site.key
  }
  [...]
% docker run -d -p 80:2015 -p 443:2378 -v /home/j/site:/var/www:ro joshix/caddy
```
