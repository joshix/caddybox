# Caddy container

Without configuration, this image encapsulates a [*Caddy*](http://caddyserver.com) HTTP server for static files.
A `/bin/caddy` server process listens on the container's `EXPOSE`d TCP port #2015 and attempts to fulfill requests with files beneath the container's `/var/www/html/`.

Content should be added by binding over that path with a host volume, or by `COPY`ing/`ADD`ing files there when `docker build`ing a custom image based on this one. Adding a Caddyfile through the same mechanisms allows configuration as described in Caddy's documentation.

## Container file system:
* `/bin/caddy` #HTTP server executable
* `/var/www/html/` #Server's working directory and HTTP name space root

### Serve a directory of static files from the docker host:
```
% ls /home/user/site
  index.html
  img/
  [...]
% docker run -p 8080:2015 -v /home/user/site/:/var/www/html/:ro -d joshix/caddy
```

### Or build the files into an image based on this one:
```
# cd /home/user/site-buildin
% ls
  Dockerfile
  index.html
  img/logo.png
  [...]
% cat Dockerfile
  FROM joshix/caddy
  COPY . /var/www/html
% docker build -t "com.mysite-caddy" .
% docker run -p 8080:80 -d com.mysite-caddy
```

### This technique allows custom configs by adding a `Caddyfile` to your host volume:
```
% ls /home/user/site
  Caddyfile
  index.md
  img/
  [...]
% cat Caddyfile
  0.0.0.0:2015
  ext .html .htm .md
  markdown /
  gzip
  [...]
% docker run -p 8080:2015 -v /home/user/site/:/var/www/html/:ro -d joshix/caddy
```

Etc.
