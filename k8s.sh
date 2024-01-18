#!/bin/bash
set -o errexit

export KUBE_PROXY_MODE=ipvs

echo install apt-key

image_url=registry.cn-hangzhou.aliyuncs.com/google_containers

apt install -y gnupg curl bash-completion ipset ipvsadm

mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo set kubernetes mirrors

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

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
