#!/bin/sh
set -eu

VM_NAME=$1

DIR="$(dirname "$(test -L "$0" && readlink "$0" || echo "$0")")"

vm_mac=$(virsh dumpxml $VM_NAME | grep -oP "mac address=\K.*'" | tr -d "'")
ip=$(arp -n | awk -v vm_mac=$vm_mac '$3==vm_mac {print $1}')
echo $ip