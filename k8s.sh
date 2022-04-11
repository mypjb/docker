#!/bin/bash
set -o errexit

echo install apt-key

#k8s version
k8s_version=v1.23.5

image_url=registry.cn-hangzhou.aliyuncs.com/google_containers

packs=(cri-tools kubernetes-cni kubelet kubectl kubeadm)

apt install -y gnupg curl bash-completion

apt-key add k8s/apt-key.gpg

echo download kubelet kubeadm kubectl kubernetes-cni cri-tools package

kubelet_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubelet_1.23.5-00_amd64_9679f0eb4bc40fe17110967eac853f0381f1fb7a29d319ed9b3c48592b83d7cd.deb

kubeadm_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubeadm_1.23.5-00_amd64_642bf36ddafb1b8a3d528708d50a68df145747ef397b55546f26879be1b81223.deb

kubectl_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubectl_1.23.5-00_amd64_d5f985a62ca1798ff59029294cf4bbf7e6e8d4ffe66559a1c9b0559a37c580f7.deb

kubernetes_cni_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubernetes-cni_0.8.7-00_amd64_ca2303ea0eecadf379c65bad855f9ad7c95c16502c0e7b3d50edcb53403c500f.deb

cri_tools_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/cri-tools_1.23.0-00_amd64_6d748dd24f90b3696e35ea3d9199e2f76ea4793371f0d0658498b1f96d9f03d3.deb

curl -L -o kubelet.deb $kubelet_pack

curl -L -o kubeadm.deb $kubeadm_pack

curl -L -o kubectl.deb $kubectl_pack

curl -L -o kubernetes-cni.deb $kubernetes_cni_pack

curl -L -o cri-tools.deb $cri_tools_pack

echo installation dependency

apt install -y iptables socat ebtables ethtool conntrack

#apt install -y kubelet kubeadm kubectl kubernetes-cni cri-tools

for pack in ${packs[@]};do
	echo install $pack
	dpkg -i ${pack}.deb
	rm ${pack}.deb
done

kubeadm config images pull --image-repository  $image_url

k8s_images=(kube-apiserver kube-controller-manager kube-scheduler kube-proxy)

for image in ${k8s_images[@]};do
	ctr -n k8s.io images tag --force ${image_url}/${image}:$k8s_version k8s.gcr.io/${image}:$k8s_version
done

k8s_dependent_images=(pause:3.6 etcd:3.5.1-0 coredns:v1.8.6)

for image in ${k8s_dependent_images[@]};do
	ctr -n k8s.io images tag --force ${image_url}/${image} k8s.gcr.io/${image}
done


echo -e "\tNow initialize the cluster with the following command\n\tkubeadm init --image-repository  ${image_url} --kubernetes-version ${k8s_version} --node-name $(hostname) --control-plane-endpoint $(hostname)  --v=5"

kubectl completion bash > /etc/bash_completion.d/kubectl
source /etc/bash_completion.d/kubectl

echo "After installation,you can run the following command to set kubectl "
echo 'echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile.d/kubernetes.sh && source /etc/profile && echo $KUBECONFIG'
