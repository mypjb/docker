- [Install CRI](#Install CRI)
- [Install Kubernetes](#Install Kubernetes)
- [Deploy Cluster](#Deploy Cluster)
- [Install Gateway](#Install Gateway)
- [Install Dashboard](#Install Dashboard)

# kubernetes Install

[Kubernetes](https://kubernetes.io) install is divided into tow parts

***_PS: Please install in document order_***

### Install CRI 

----
The script install [containerd]((https://github.com/containerd/containerd)) and configures it as the runtime of the [Kubernetes](https://kubernetes.io) container

```shell
./cri.sh
```
### Install Kubernetes

---

Install [Kubernetes](https://kubernetes.io) software package. Here we use a third-party [mirror](https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/) station for install

```shell
./k8s.sh
```

### Deploy Cluster

---

You can create or join a cluster using following command

```shell
#Create a new cluster
kubeadm init --image-repository  registry.cn-hangzhou.aliyuncs.com/mypjb --node-name $(hostname) --control-plane-endpoint $(hostname)  --v=5
```

### Install Gateway

---

Install gateway plugin [gloo](https://github.com/solo-io/gloo)

```shell
./gloo.sh
```

#### Install Dashboard

Install [Kubernetes](https://kubernetes.io) [dashboard](https://github.com/kubernetes/dashboard)

```shell
./dashboard.sh
#use default user manage
kubectl apply -f dashboard/userSetting.yaml
#use gateway
./dashboard.sh gloo
```

