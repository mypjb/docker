#!/bin/bash

echo install apt-key

apt-key add k8s/apt-key.gpg

echo download kubelet kubeadm kubectl kubernetes-cni cri-tools package

curl -L -o kubelet.deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubelet_1.22.1-00_amd64_240cc59b5f8e44719af21b90161d32297679376f5a4d45ffd4795685ef305538.deb
curl -L -o kubeadm.deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubeadm_1.22.1-00_amd64_2e8580f3165ea2f19ba84ac4237dad873cc9915214b3f8f5ca2e98c7a8ecd3e1.deb
curl -L -o kubectl.deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubectl_1.22.1-00_amd64_2a00cd912bfa610fe4932bc0a557b2dd7b95b2c8bff9d001dc6b3d34323edf7d.deb

curl -L -o kubernetes-cni.deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubernetes-cni_0.8.7-00_amd64_ca2303ea0eecadf379c65bad855f9ad7c95c16502c0e7b3d50edcb53403c500f.deb

curl -L -o cri-tools.deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/cri-tools_1.13.0-01_amd64_4ff4588f5589826775f4a3bebd95aec5b9fb591ba8fb89a62845ffa8efe8cf22.deb
echo installation dependency

apt install -y iptables socat ebtables ethtool conntrack

echo install cri-tools
dpkg -i cri-tools.deb

echo install kubernetes-cni
dpkg -i kubernetes-cni.deb

echo install kubelet
dpkg -i kubelet.deb 

echo kubectl kubelet
dpkg -i kubectl.deb 

echo install kubeadm
dpkg -i kubeadm.deb 
