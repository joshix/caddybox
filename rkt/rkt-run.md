# Running caddybox with rkt

See also the [`jxnu.service` systemd unit][jxnu-unit] that runs
the joshix.com site container, and [`caddy-rkt.service`][caddy-rkt-unit], the unit that runs the testbed caddybox at jxnu.joshix.com.

## Caddybox Docker image from container registry

With the converted Docker image pulled from Quay, we don't have named ports to
map, so we once gave the 'net=host' option. However, [rkt gives a conventional
name to Docker EXPOSEd ports][rkt-docker-expose].

Similarly, the container's mount points aren't labeled, so we provide both the
`volume` the host is serving and the `mount` target for it inside the container.
Caddy does know its working directory from the Dockerfile, so we don't have to
mount a `/Caddyfile` -- dropping it in the volume that gets mounted at
`/var/www/html` inside the container is sufficient.

Note: `caddy` has the working directory `/var/www/html` inside this converted Docker container.

```sh
sudo systemd-run --slice=machine \
rkt run --insecure-options=image \
--port=80-tcp:80 --port=443-tcp:443 --port=2015-tcp:2015 \
--dns 8.8.8.8 --dns 8.8.4.4 \
--volume html,kind=host,source=/home/core/web/public,readOnly=true \
--mount volume=html,target=/var/www/html \
--volume dotcaddy,kind=host,source=/home/core/dotcaddy,readOnly=false \
--mount volume=dotcaddy,target=/root/.caddy \
docker://quay.io/joshix/caddy:v1.0.0
```


[caddy-rkt-unit]: caddy-rkt.service
[jxnu-unit]: https://github.com/joshix/jxnu/blob/0ad6717bee2db53e7cb501c92620be961772ca63/jxnu.service
[rkt-docker-expose]: https://github.com/coreos/rkt/commit/443073354c7d2bb40a3f69d520f4f45f69f2f31d
