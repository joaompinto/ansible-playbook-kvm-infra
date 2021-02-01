# masterkube1

This repository provides an ansible playbook to install a multinode kubernetes cluster using KVM on a single host.

Requirements:
 - Ubuntu 20.04
 - RAM: 32GB



```sh
sudo apt install ansible
ansible-galaxy collection install  -r requirerements.yml
```

Run the full playbook
```sh
ansible-playbook ansible-playbooks/full.yml
```


References:
- https://git.fslab.de/aeber12s/ansible-vmhost
