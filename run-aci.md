# Running caddybox with rkt

See also the [`jxnu-aci.service` systemd unit][jxnu-aci-unit] that runs
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

Note: `caddy` has the working directory `/var/www/html` inside this converted Docker container; but working directory `/` inside the ACI.
Note different mount targets for `Caddyfile` for the two different containers.

```sh
sudo systemd-run --slice=machine \
rkt run --insecure-options=image \
--port=80-tcp:80 --port=443-tcp:443 --port=2015-tcp:2015 \
--dns 8.8.8.8 --dns 8.8.4.4 \
--volume html,kind=host,source=/home/core/web/public,readOnly=true \
--mount volume=html,target=/var/www/html \
--volume dotcaddy,kind=host,source=/home/core/dotcaddy,readOnly=false \
--mount volume=dotcaddy,target=/root/.caddy \
docker://quay.io/josh_wood/caddy:0.9.5
```

## Caddybox ACI from file

### Basic rkt run

Serve the included /var/www/html/index.html on host:32768. The aci names
container port 2015 `http-alt`.

```sh
sudo rkt run --insecure-options=image --port http-alt:32768 \
caddy-v0.9.5-linux-amd64.aci
```

### Serving an https site from an html volume

The caddybox ACI names three ports, so we can map just some set
of those and not give access to the entire host network namespace.

Similarly, we can name just the *volumes* the host supplies,
because some of the mount points inside the container are
enumerated in the ACI.  
**Except** the `caddyfile` mount, which does not exist in
the ACI, but can be bound to `/Caddyfile` there, where caddy
will read it because caddy's working directory is `/` in the
container.  
**Except** the `html` mount, which is not named in the ACI,
because the aci contains a default `/var/www/html/index.html`.

```sh
sudo rkt run --insecure-options=image \
--port http:80 --port https:443 [--port http-alt:2015] \
--dns 8.8.8.8 --dns 8.8.4.4 \
--volume caddyfile,kind=host,source=/home/core/web/Caddyfile,readOnly=true \
--mount volume=caddyfile,target=/Caddyfile \
--volume html,kind=host,source=/home/core/web/public,readOnly=true \
--mount volume=html,target=/var/www/html \
--volume dotcaddy,kind=host,source=/home/core/dotcaddy,readOnly=false \
caddy-v0.9.5-linux-amd64.aci
```


[caddy-rkt-unit]: https://github.com/joshix/caddybox/blob/master/caddy-rkt.service
[jxnu-aci-unit]: https://github.com/joshix/jxnu/blob/master/jxnu-aci.service
[rkt-docker-expose]: https://github.com/coreos/rkt/commit/443073354c7d2bb40a3f69d520f4f45f69f2f31d
