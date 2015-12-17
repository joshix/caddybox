# Let's Encrypt Caddybox

This is a temporary supplement to the [README](README.md), for eventual incorporation there.

## Pro
* Simple HTTPS in a container

## Con
* `/bin/caddy` now runs as `EUID O` (root) in the container

  Caddy must bind low ports to most simply do TLS. `set_cap` is not simple (possible?) to reflect into the container.

### How

#### Caddyfile required

Create a Caddyfile specifying, at minimum, a domain name resolving to the docker host that will arrange for such traffic to be handled by the running caddybox container, and the email address for registration with letsencrypt.

```sh
$ ls /home/j/site
Caddyfile
index.html
$ cat /home/j/site/Caddyfile
lecaddybox.wood-racing.com
  tls j@joshix.com
$ docker run --name com.wood-racing.lecaddybox -d -p 80:80 -p 443:443 -v /home/j/site:/var/www/html:ro joshix/caddy:le
```

### Persisting

 Certificates and keys generated in the letsencrypt exchange are written to PEM-encoded files beneath the container’s `/.caddy/letsencrypt/`. They can be copied out of the container file system with the `docker cp` command, e.g.:

```sh
$ docker cp com.wood-racing.lecaddybox:/.caddy/letsencrypt /backup/letsencrypt/
```

From there, build the certificate/key pair back into an image, or mount them in a volume attached to a container.
