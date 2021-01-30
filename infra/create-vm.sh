
#!/bin/sh
set -eu

export NODE_NAME=$1
export RAM=$2
export CPU=$3
export DISKSIZE=$4

DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. $DIR/etc/env

export PUB_KEY="$(cat ~/.ssh/id_ed25519.pub)"

TMP_DIR=$(mktemp -d)
trap '{ rm -rf $TMP_DIR }' EXIT

envsubst < $DIR/etc/cloud_init.cfg > $TMP_DIR/cloud_init.cfg
cloud-localds -v \
    --network-config=$DIR/etc/network_config_static.cfg \
    $TMP_DIR/seed.img $TMP_DIR/cloud_init.cfg

setfacl -Rm user:libvirt-qemu:rwx $TMP_DIR


DISK_PATH=~/disks/$NODE_NAME.img
qemu-img create -b ~/base/focal-server-cloudimg-amd64-disk-kvm.img -f qcow2 -F qcow2 $DISK_PATH ${DISKSIZE}G

virt-install --name test1   \
    --virt-type kvm --memory 2048 --vcpus 2   \
    --boot hd,menu=on   \
    --graphics none \
    --disk path=$DISK_PATH,cache=none   \
    --disk path=$TMP_DIR/seed.img,device=disk  \
    --os-type Linux --os-variant ubuntu20.04   \
    --network bridge=virbr0,model=virtio    
    #--noautoconsole
