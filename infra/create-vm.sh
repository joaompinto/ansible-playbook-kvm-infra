#!/bin/sh
set -eu

export NODE_NAME=$1
export RAM=$2
export CPU=$3
export DISKSIZE=$4
export VARSIZE=$5
export IP=$6

DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. $DIR/etc/env
echo 
pwd

export MCK_NET=$(virsh net-dumpxml mck | grep -oP "ip address='\K\d+\.\d+.\d+")

export PUB_KEY="$(cat $HOME/.ssh/id_ed25519.pub)"

#TMP_DIR=$(mktemp -d)
#trap "rm -rf $TMP_DIR" EXIT

VAR_DIR=$DIR/../var

mkdir -p $VAR_DIR

envsubst < $DIR/etc/cloud_init.cfg > $VAR_DIR/cloud_init_$NODE_NAME.cfg
envsubst < $DIR/etc/network_config.cfg > $VAR_DIR/network_config_$NODE_NAME.cfg
cloud-localds -v \
    --network-config=$VAR_DIR/network_config_$NODE_NAME.cfg \
    $VAR_DIR/seed_$NODE_NAME.img $VAR_DIR/cloud_init_$NODE_NAME.cfg

set +e
setfacl -m user:libvirt-qemu:rwx $VAR_DIR 2>/dev/null
setfacl -m user:libvirt-qemu:rwx $HOME $DIR/.. 2>/dev/null
set -e

DISK_PATH=~/disks/$NODE_NAME.img
qemu-img create -b ~/base/focal-server-cloudimg-amd64-disk-kvm.img -f qcow2 -F qcow2 $DISK_PATH ${DISKSIZE}G
qemu-img create -f raw ~/disks/${NODE_NAME}_var.img  ${VARSIZE}G

virt-install --name mck-$NODE_NAME \
    --virt-type kvm --memory 2048 --vcpus 2   \
    --boot hd,menu=on   \
    --graphics none \
    --disk path=$DISK_PATH  \
    --disk path=$VAR_DIR/seed_${NODE_NAME}.img,device=disk,readonly=on  \
    --disk path=$HOME/disks/${NODE_NAME}_var.img \
    --os-type Linux --os-variant ubuntu20.04   \
    --network bridge=mck-br,model=virtio    \
    --noautoconsole

echo "Waiting for the new node to acquire the IP address"
IP=""
until [ -n "$IP" ]
do
    IP=$($DIR/../utils/virt2ip.sh mck-$NODE_NAME)
    sleep 1
done
echo $IP
$DIR/../utils/deploy-ssh-config.sh $NODE_NAME $IP
echo 
echo You can now login using:
echo "   ssh $NODE_NAME"
