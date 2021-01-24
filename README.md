# masterkube1

## knockd setup

https://www.howtogeek.com/442733/how-to-use-port-knocking-on-linux-and-why-you-shouldnt/

## How to connect from docker
```sh
docker run -it ubuntu
apt-get update
apt-get install -y knockd
knock 192.168.1.145 4431 5119 6542
```
## Bash history logging
```sh
cat /etc/profile.d/command.sh
export PROMPT_COMMAND='history -a >(tee -a ~/.bash_history | logger -t "$USER[$$] $SSH_CONNECTION")'
```

## Enable libvirt
```sh
sudo apt install qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```

# Setup bridge interface
https://ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/


# Get the base image
mkdir -p ~/base
BASE_IMAGE="focal-server-cloudimg-amd64-disk-kvm.img"
DOWNLOAD_LINK=https://cloud-images.ubuntu.com/focal/current/$BASE_IMAGE
wget -c ${DOWNLOAD_LINK} -P ~/base

# Create the master node
```sh
qemu-img create -b ~/base/$BASE_IMAGE -f qcow2 -F qcow2 ~/disks/master1.img 10G


cloud-localds -v --network-config=network_config_static.cfg test1-seed.img cloud_init.cfg

virt-install \
    --name=master1 \
    --ram=2048 --vcpus=1 \
    --boot hd,menu=on \
    --disk path=test1-seed.img,device=cdrom \
    --disk path=~/disks/master1.img,device=disk \
    --os-type Linux --os-variant ubuntu20.04 \
    --network bridge=br0,model=virtio \
    --noautoconsole

cat > host-bridge.xml << _EOF_
<network>
  <name>host-bridge</name>
  <forward mode="bridge"/>
  <bridge name="br0"/>
</network>
_EOF_

virsh net-define host-bridge.xml
virsh net-start host-bridge
sudo usermod -aG kvm mckadm
