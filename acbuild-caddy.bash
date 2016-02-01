#!/usr/bin/env bash
set -e

# Start the build with the caddybox root file system.
acbuild --debug begin ./rootfs

# In the event of the script exiting, end the build
acbuildEnd() {
    export EXIT=$?
    acbuild --debug end && exit $EXIT
}
trap acbuildEnd EXIT

# Name the ACI
acbuild --debug set-name joshix.com/caddy

# Add ports for HTTP, HTTPS, and Caddy's default unprivileged port.
acbuild --debug port add http tcp 80
acbuild --debug port add https tcp 443
acbuild --debug port add http-alt tcp 2015

# Add mount points in the container for html files, the let's encrypt
# key store, and a name resolver configuration.
# Simple case: 'rkt run --net=host' and you will serve the included
# default index.html over port 2015. No https, no keys to lose in the
# empty volume mount for dotcaddy, and no name resolution in the container.
# To serve a real site, provide volumes for all four of these, and mount
# the first two.
acbuild --debug mount add caddyfile /Caddyfile
#acbuild --debug mount add html /var/www/html
acbuild --debug mount add dotcaddy /root/.caddy
acbuild --debug mount add resolv /etc/resolv.conf

# How to execute caddy
acbuild --debug set-exec -- /bin/caddy -root /var/www/html

# Save the ACI
acbuild --debug write --overwrite caddy-v0.8.1-linux-amd64.aci
