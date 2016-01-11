#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# Start the build with an empty ACI
acbuild --debug begin

# In the event of the script exiting, end the build
acbuildEnd() {
    export EXIT=$?
    acbuild --debug end && exit $EXIT 
}
trap acbuildEnd EXIT

# Name the ACI
acbuild --debug set-name joshix.com/caddy

# Copy the file system
acbuild --debug copy rootfs/bin/caddy /bin/caddy
acbuild --debug copy rootfs/etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
acbuild --debug copy rootfs/var/www/html/index.html /var/www/html/index.html

# Add a port for http traffic over port 80
acbuild --debug port add http tcp 80
acbuild --debug port add https tcp 443
acbuild --debug port add http-alt tcp 2015

# Add a mount point for files to serve
#acbuild --debug mount add html /var/www/html

# Run nginx in the foreground
acbuild --debug set-exec -- /bin/caddy -root /var/www/html

# Save the ACI
acbuild --debug write --overwrite caddy-v0.8.0-linux-amd64.aci
