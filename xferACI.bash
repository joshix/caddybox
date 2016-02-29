# Obviously not an actual script yet

$ cd $HOME/go/src/github.com/joshx/acbuild
towncar:acbuild j$ scp -i .vagrant/machines/default/virtualbox/private_key -P 2222 vagrant@127.0.0.1:caddybox/caddy-v0.8.2-linux-amd64.aci ~/Downloads/
caddy-v0.8.2-linux-amd64.aci                  100% 3866KB   3.8MB/s   00:00
towncar:acbuild j$ scp ~/Downloads/caddy-v0.8.2-linux-amd64.aci core@jxnu.joshix.com:
caddy-v0.8.2-linux-amd64.aci                  100% 3866KB   1.3MB/s   00:03
towncar:acbuild j$
