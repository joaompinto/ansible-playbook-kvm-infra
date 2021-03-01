
# Deploy a k8s cluster using kubespray
```
su - akvmadm
git clone https://github.com/kubernetes-sigs/kubespray
cd kubespray
ansible-playbook cluster.yml -ekube_proxy_mode=iptables -i /home/akvmadm/etc infra.ini --become
```