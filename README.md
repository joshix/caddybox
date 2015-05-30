# Caddy container

Without configuration, this image encapsulates a static file HTTP server container running Caddy.
It listens on exposed port #2015 and attempts to fulfill requests using files in the container's /var/www/html/.
Adding a Caddyfile (see below) allows configuration as described in Caddy's documentation(link).

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
