#!/bin/bash

cd $GOPATH/src/github.com/joshix/acbuild

scp -i .vagrant/machines/default/virtualbox/private_key -P 2222 \
vagrant@127.0.0.1:caddybox/caddy-v0.8.3-linux-amd64.aci ~/Downloads/

scp ~/Downloads/caddy-v0.8.3-linux-amd64.aci core@jxnu.joshix.com:
