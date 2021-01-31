#!/bin/bash

set -eu

DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

function cdr2mask () {
    # Number of args to shift, 255..255, first non-255 byte, zeroes
    set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
    [ $1 -gt 1 ] && shift $1 || shift
    echo ${1-0}.${2-0}.${3-0}.${4-0}
}

function create_libvirt_network() {
    network=$(echo $1| cut -d"/" -f1)
    netmask=$(cdr2mask $(echo $1| cut -d"/" -f2))
    echo $network $netmask
    TMP_FILE=$(mktemp)
    trap "rm -f $TMP_FILE" EXIT    
    cp $DIR/etc/networks/mck.xml $TMP_FILE
    sed -i "s~%NETWORK%~${network}~g" $TMP_FILE
    sed -i "s~%NETMASK%~${netmask}~g" $TMP_FILE
    virsh net-define $TMP_FILE
    virsh net-start mck
    virsh net-autostart mck
    virsh net-list
}


create_libvirt_network $1
