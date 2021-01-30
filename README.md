# masterkube1

## Setup firewall + knockd

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

# Networking for the VMs

Removed libvirt's default bridge and setup a real bridge (br0) with the ethernet interface:
https://ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/

Create libvirt network for the host bridge:
```sh
cat > host-bridge.xml << _EOF_
<network>
  <name>host-bridge</name>
  <forward mode="bridge"/>
  <bridge name="br0"/>
</network>
_EOF_


virsh net-define host-bridge.xml
virsh net-start host-bridge
```

# Create cluster infra adm user

```sh
user adduser mckadm
sudo usermod -aG kvm mckadm
sudo su - mckadm
ssh-keygen -t ed25519

```

# Get the Ubuntu image for the nodes


# Create the master node

utils/download-image.sh

sudo apt install libnss-libvirt
sed -i s'/\(hosts:\W.*\)/\1 files libvirt libvirt_guest dns mymachines/' /etc/nsswitch.conf

# hostname, ram, cpus, disk_size
infra/create-vm.sh master1 2048 1 10
