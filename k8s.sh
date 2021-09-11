#!/bin/bash

apt-get install -y libseccomp2

curl -L -o cri-containerd-cni-linux-amd64.tar.gz https://github.com/containerd/containerd/releases/download/v1.5.5/cri-containerd-cni-1.5.5-linux-amd64.tar.gz

tar --no-overwrite-dir -C / -xzf cri-containerd-cni-linux-amd64.tar.gz

rm -rf cri-containerd-cni-linux-amd64.tar.gz

systemctl enable containerd

mkdir -p /etc/systemd/system/kubelet.service.d

cat <<EOF | tee /etc/systemd/system/kubelet.service.d/0-containerd.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=unix:///run/containerd/containerd.sock --cgroup-driver=systemd"
EOF

cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF


cat <<EOF |  tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

mkdir -p /etc/containerd

containerd config default | tee /etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

systemctl daemon-reload

systemctl start containerd

crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock 
crictl config --set image-endpoint=unix:///run/containerd/containerd.sock

echo -e '\tIf you do not configure the default kubedm container runtime, the following commands are recommended \n\techo -e "export CONTAINER_RUNTIME_ENDPOINT=unix:///run/containerd/containerd.sock\\nexport IMAGE_SERVICE_ENDPOINT=unix:///run/containerd/containerd.sock" >> /etc/profile'
