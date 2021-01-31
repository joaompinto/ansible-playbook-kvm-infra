#!/bin/sh

hostname=$1
ip=$2

[ ! -d ~/.ssh ] && mkdir -m700 ~/.ssh
[ ! -f ~/.ssh/config ] && echo >> ~/.ssh/config

    sed -i 's/^Host/\n&/' ~/.ssh/config
    sed -i '/^Host '"$hostname"'$/,/^$/d;/^$/d' ~/.ssh/config
    cat << _EOF_ >> ~/.ssh/config
Host ${hostname}
    Hostname $ip
    User ubuntu
_EOF_
ssh-keygen -f ~/.ssh/known_hosts -R "$ip" > /dev/null 2>&1 || true
chmod 700 ~/.ssh/config
