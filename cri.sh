#!/bin/bash
set -o errexit

containerd_version=1.7.11

containerd_install_file=cri-containerd-cni-linux-amd64.tar.gz

container_runtime_endpoint=unix:///run/containerd/containerd.sock

apt-get install -y libseccomp2 curl

if [ "${1}" == "install" ];then

  if [ -f "${containerd_install_file}" ];then
  
  	echo "containerd package file exit"
  	
  else
  
  	echo "download containerd install package"
  
  	curl -L -o $containerd_install_file https://github.com/containerd/containerd/releases/download/v${containerd_version}/cri-containerd-cni-${containerd_version}-linux-amd64.tar.gz
  
  fi

  echo "decompression and install containerd"

  tar --no-overwrite-dir -C / -xzf $containerd_install_file
  
  echo -e "rm install package ${containerd_install_file}"
  
  rm -rf $containerd_install_file
  
  echo "start-up containerd";
  
  systemctl enable containerd
  
  systemctl daemon-reload
  
  systemctl start containerd

  return;

fi

mkdir -p /etc/systemd/system/kubelet.service.d

echo "write kubelet service container config"

echo "setting k8s container cgroup and container-runtime"

cat <<EOF | tee /etc/systemd/system/kubelet.service.d/0-containerd.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=${container_runtime_endpoint} --cgroup-driver=systemd"
EOF

echo "setting k8s container load module"

cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack
EOF

modprobe overlay
modprobe br_netfilter
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack

echo "setting k8s container network"

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
echo "create containerd default config and setting 'SystemdCgroup=true'"
containerd config default | tee /etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

systemctl daemon-reload

systemctl start containerd

echo "setting k8s crictl container-runtime"
crictl config --set runtime-endpoint=${container_runtime_endpoint} 
crictl config --set image-endpoint=${container_runtime_endpoint}

sed -i 's/config_path = ""/config_path = "\/etc\/containerd\/certs.d"/g'  /etc/containerd/config.toml
sed -i 's/k8s.gcr.io/registry.cn-hangzhou.aliyuncs.com\/google_containers/g'  /etc/containerd/config.toml

mkdir -p /etc/containerd/certs.d/docker.io

cat > /etc/containerd/certs.d/docker.io/hosts.toml << EOF
#server = "https://docker.mirrors.ustc.edu.cn"

[host."https://hub-mirror.c.163.com"]
  capabilities = ["pull", "resolve"]
[host."https://registry-1.docker.io"]
  capabilities = ["pull", "resolve"]
EOF

systemctl restart containerd
