#!/bin/bash

# Builds caddy binary for caddybox rootfs using caddy's build.go.
#
# Usage: ./buildcaddy.bash $tag (Ex: v0.10.11)
# Assumes cwd is go/src/github.com/joshix/caddybox.

tag=$1

go get -u -v -d github.com/mholt/caddy
go get -u -v github.com/caddyserver/builds
cd ../../mholt/caddy
git checkout master
cd caddy
go clean
go get -u -v -d
if [ "$tag" != '' ]
  then
    git checkout $tag
fi
go run build.go --goos linux --goarch amd64
cp caddy ../../../joshix/caddybox/rootfs/bin/caddy
