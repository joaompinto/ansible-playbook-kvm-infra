# Ansible Playbook for KVM Infra management
This playbook is designed to define and manage networks and guests on a KVM host from an infra manifest(YAML). It is designed for lab/dev work, where the KVM host is a local machine and you have sudo privileges.

Example of a bridged network interface and one vm:
```yaml
vmhost_network:
    - netname: mck
      bridge_name: br-mck
      net4_address: '192.168.8.0/24'
      net4_dhcp: True

nodes:
    - name: mck-master1    
      cpu: 1
      mem: 1024
      root_size: 10
      var_size: 20
      network: { name: mck, ip: 192.168.8.10 }
```    

To operate the KVM sources managed by this playbook the user _akvmadm_ is created.


## Requirements
The playbook was developed/tested to be run x86_64 host running Ubuntu 20.04 LTS.
All the requires packages and services are installed/setup by this playbook, no manual setup is required. The required ammount of RAM will depend on your infrastructure setup.

### Install Ansible
Login with your individual user and setup ansible/ansible-galaxy:
```sh
sudo apt install ansible
ansible-galaxy collection install  -r requirerements.yml
```
## Setup the KVM Host
Run KVM host setup playbook
```sh
ansible-playbook ansible-playbooks/kvm-host.yml
```
## Deploy Infra to KVM
Adjust [infra.yml](ansible-playbooks/etc/infra.yml) to your needs.

:warning: Do not overlap network and vm names with existing KVM resources from other projects-

Deploy the defined infra:
```sh
ansible-playbook ansible-playbooks/infra.yml
```

Test the new infra:
```sh
# Test the ansible setup
sudo su - akvmadm -c 'ansible all -m ping'

# Login into the new node to test it
sudo su - akvmadm -c 'ssh mck-master1'
```
## Destroying the managed KVM infra
```
ansible-playbook ansible-playbooks/destroy-infra.yml
sudo userdel -r akvmadm
```
