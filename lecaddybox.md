# Let's Encrypt Caddybox

This is a temporary supplement to the [README](README.md), for eventual incorporation there.

## Pro
* Simple HTTPS in a container

## Con
* `/bin/caddy` now runs as `EUID O` (root) in the container

  Caddy must bind low ports to most simply do TLS. `set_cap` is not simple (possible?) to reflect into the container.

## How

### Caddyfile required

Create a Caddyfile specifying, at minimum, a domain name resolving to the docker host that will arrange for such traffic to be handled by the running caddybox container, and the email address for registration with letsencrypt.

```sh
$ ls /home/j/lecaddybox/html
Caddyfile
index.html
$ cat /home/j/lecaddybox/html/Caddyfile
lecaddybox.wood-racing.com
  tls j@joshix.com
$ docker run --name com.wood-racing.lecaddybox -d \
-p 80:80 -p 443:443 \
-v /home/j/lecaddybox/html:/var/www/html:ro \
-v /home/j/lecaddybox/dotcaddy:/.caddy:rw \
joshix/caddy:le
```

### Persisting

 Certificates, keys, and configuration generated in the letsencrypt exchange are written to files beneath the container’s `/.caddy/letsencrypt/`. The example above arranges for that path to be a Docker *volume*, backing the container's `/.caddy/` directory with a host directory, `/home/j/lecaddybox/dotcaddy/`.

They can be copied out of the container file system with the `docker cp` command, e.g.:

```sh
$ docker cp com.wood-racing.lecaddybox:/.caddy/letsencrypt /backup/letsencrypt
```
