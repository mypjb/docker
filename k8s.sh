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

kubelet_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubelet_1.22.3-00_amd64_59638c5e6a1f6ffa59569efc8bd8bcdd00709dfdf5b11f209491cb30b9c546f5.deb

kubeadm_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubeadm_1.22.3-00_amd64_18966903d3cc24909e806b8f28f7a25a408d0a89c4ce6555e186ed2364f21c3c.deb

kubectl_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubectl_1.22.3-00_amd64_41b047d8823ded626c16f65fb9af0c8b0ef983815aeb2bbd9ae38c19d2471393.deb

kubernetes_cni_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/kubernetes-cni_0.8.7-00_amd64_ca2303ea0eecadf379c65bad855f9ad7c95c16502c0e7b3d50edcb53403c500f.deb

cri_tools_pack=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/cri-tools_1.19.0-00_amd64_b6fdfd86c8a3665ab10b9bd9565354977cd5abbaefeb2ee953bc4a13fe7d3326.deb

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
	rm ${pack}.deb
done

kubeadm config images pull --image-repository  $image_url

k8s_images=(kube-apiserver kube-controller-manager kube-scheduler kube-proxy)

for image in ${k8s_images[@]};do
	ctr -n k8s.io images tag ${image_url}/${image}:$k8s_version k8s.gcr.io/${image}:$k8s_version
done

k8s_dependent_images=(pause:3.5 etcd:3.5.0-0 coredns:v1.8.4)

for image in ${k8s_dependent_images[@]};do
	ctr -n k8s.io images tag ${image_url}/${image} k8s.gcr.io/${image}
done


echo -e "\tNow initialize the cluster with the following command\n\tkubeadm init --image-repository  ${image_url} --kubernetes-version ${k8s_version} --node-name $(hostname) --control-plane-endpoint $(hostname)  --v=5"

kubectl completion bash > /etc/bash_completion.d/kubectl

echo "After installation,you can run the following command to set kubectl "
echo 'echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile.d/kubernetes.sh && source /etc/profile && echo $KUBECONFIG'
