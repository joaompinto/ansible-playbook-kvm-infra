# masterkube1

Requirements:
 - Ubuntu 20.04
 - RAM: 32GB

```sh
sudo apt install ansible
ansible-galaxy collection install  -r requirerements.yml
```

Setup the system requirements
```sh
ansible-playbook ansible-playbooks/pre-requirements.yaml
```

## Bash history logging
```sh
cat /etc/profile.d/command.sh
export PROMPT_COMMAND='history -a >(tee -a ~/.bash_history | logger -t "$USER[$$] $SSH_CONNECTION")'
```

# Networking for the VMs


# Get the Ubuntu image for the nodes

utils/download-image.sh

# Use a local bridge on subnet 192.168.8.1
infra/create-net.sh 192.168.8.1/24

# Create the master node

# hostname, ram, cpus, root_disk_size, var_disk_size, ipdigit
infra/create-vm.sh master1 2048 1 10 20 100


pip3 install lxml 
ansible-galaxy collection install community.libvirt
