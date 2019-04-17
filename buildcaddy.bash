#!/bin/bash

# Build caddy binary for caddybox using caddy's build.go.
#
# Usage: ./buildcaddy.bash <git tag>
# Assumes the path ../../mholt/caddy/ can be reached.

tag=$1

GO111MODULE=on export GO111MODULE

cd ../../mholt/caddy
git checkout master
if [ "$tag" != '' ]
  then
    git checkout $tag
fi
cd caddy
go clean
GOOS=linux GOARCH=amd64 go build
cp ./caddy ../../../joshix/caddybox/rootfs/bin/caddy
go clean
git checkout master
