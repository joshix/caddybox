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

# Add expected mount point for the let's encrypt key store. Don't enumerate
# the html directory or the Caddyfile, so that they won't have an empty
# directory mounted over them.
# This allows for the simple case: 'rkt run --port http-alt:2015 caddy.aci'
# will serve the included default index.html over port 2015.
# To serve a real site, provide volumes for all three of these to rkt run,
# along with mounts for the first two. Add --dns options for name resolution.
#acbuild --debug mount add caddyfile /Caddyfile
#acbuild --debug mount add html /var/www/html
acbuild --debug mount add dotcaddy /root/.caddy

# How to execute caddy
acbuild --debug set-exec -- /bin/caddy -root /var/www/html

# Save the ACI
acbuild --debug write --overwrite caddy-v0.9.1-linux-amd64.aci
