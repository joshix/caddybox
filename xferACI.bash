#!/bin/bash

ACI=caddy-v0.9-beta.2-linux-amd64.aci
SSH=core@jxnu.joshix.com

scp -i $GOPATH/src/github.com/joshix/acbuild/.vagrant/machines/default/virtualbox/private_key -P 2222 \
vagrant@127.0.0.1:caddybox/$ACI .

scp $ACI $SSH:
