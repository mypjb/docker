#!/bin/bash
set -o errexit

export KUBE_PROXY_MODE=ipvs

echo install apt-key

image_url=registry.cn-hangzhou.aliyuncs.com/google_containers

apt install -y gnupg curl bash-completion ipset ipvsadm

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
apt-key add k8s/apt-key.gpg

echo set kubernetes mirrors

echo "deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

echo installation

apt update

apt install -y kubelet kubeadm kubectl kubernetes-cni cri-tools

kubeadm config images pull --image-repository  $image_url

echo -e "\tNow initialize the cluster with the following command\n\tkubeadm init --image-repository  ${image_url} --node-name $(hostname) --control-plane-endpoint $(hostname)  --v=5"

kubectl completion bash > /etc/bash_completion.d/kubectl

source /etc/bash_completion.d/kubectl

crictl completion bash > /etc/bash_completion.d/crictl

source /etc/bash_completion.d/crictl

echo "After installation,you can run the following command to set kubectl "
echo 'echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile.d/kubernetes.sh && source /etc/profile && echo $KUBECONFIG'
