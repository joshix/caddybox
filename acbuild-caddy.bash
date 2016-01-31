#!/usr/bin/env bash
set -e

# Start the build with an empty ACI
acbuild --debug begin ./rootfs

# In the event of the script exiting, end the build
acbuildEnd() {
    export EXIT=$?
    acbuild --debug end && exit $EXIT
}
trap acbuildEnd EXIT

# Name the ACI
acbuild --debug set-name joshix.com/caddy

# Add a ports for HTTP(S) traffic, Caddy default
acbuild --debug port add http tcp 80
acbuild --debug port add https tcp 443
acbuild --debug port add http-alt tcp 2015

# Add a mount point for files to serve
acbuild --debug mount add html /var/www/html
acbuild --debug mount add dotcaddy /.caddy
acbuild --debug mount add resolv /etc/resolv.conf

# How to execute caddy
acbuild --debug set-exec -- /bin/caddy -root /var/www/html -conf /var/www/html/Caddyfile

# Save the ACI
acbuild --debug write --overwrite caddy-v0.8.1-linux-amd64.aci
