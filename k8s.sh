#!/bin/bash

echo install apt-key

#k8s version
k8s_version=v1.22.1

image_url=registry.cn-hangzhou.aliyuncs.com/mypjb

packs=(cri-tools kubernetes-cni kubelet kubectl kubeadm)

apt install -y gnupg curl bash-completion

apt-key add k8s/apt-key.gpg

echo download kubelet kubeadm kubectl kubernetes-cni cri-tools package

kubelet_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubelet_1.22.1-00_amd64_240cc59b5f8e44719af21b90161d32297679376f5a4d45ffd4795685ef305538.deb

kubeadm_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubeadm_1.22.1-00_amd64_2e8580f3165ea2f19ba84ac4237dad873cc9915214b3f8f5ca2e98c7a8ecd3e1.deb

kubectl_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubectl_1.22.1-00_amd64_2a00cd912bfa610fe4932bc0a557b2dd7b95b2c8bff9d001dc6b3d34323edf7d.deb

kubernetes_cni_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubernetes-cni_0.8.7-00_amd64_ca2303ea0eecadf379c65bad855f9ad7c95c16502c0e7b3d50edcb53403c500f.deb

cri_tools_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/cri-tools_1.13.0-01_amd64_4ff4588f5589826775f4a3bebd95aec5b9fb591ba8fb89a62845ffa8efe8cf22.deb

curl -L -o kubelet.deb $kubelet_pack

curl -L -o kubeadm.deb $kubeadm_pack

curl -L -o kubectl.deb $kubectl_pack

curl -L -o kubernetes-cni.deb $kubernetes_cni_pack

curl -L -o cri-tools.deb $cri_tools_pack

echo installation dependency

apt install -y iptables socat ebtables ethtool conntrack

for pack in ${packs[@]};do
	echo install $pack
	dpkg -i ${pack}.deb
done


echo -e 'pull zh image-repository "${image_url}"'

kubeadm config images pull --image-repository  $image_url

k8s_images=(kube-apiserver kube-controller-manager kube-scheduler kube-proxy)

for image in ${k8s_images[@]};do
	ctr -n k8s.io images tag ${image_url}/${image}:$k8s_version k8s.gcr.io/${image}:$k8s_version
done

k8s_dependent_images=(pause:3.5 etcd:3.5.0-0 coredns:v1.8.4)

for image in ${k8s_dependent_images[@]};do
	ctr -n k8s.io images tag ${image_url}/${image} k8s.gcr.io/${image}
done


echo -e "\tNow initialize the cluster with the following command\n\tkubeadm init --image-repository  registry.cn-hangzhou.aliyuncs.com/mypjb --node-name $(hostname) --control-plane-endpoint $(hostname)  --v=5"

kubectl completion bash > /etc/bash_completion.d/kubectl
