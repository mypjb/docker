# kubernetes Install

[Kubernetes](https://kubernetes.io) installation is divided into tow parts

***_PS: Please install in document order_***

### Part I 

----
The script installs [containerd]((https://github.com/containerd/containerd)) and configures it as the runtime of the [Kubernetes](https://kubernetes.io) container

```shell
./cri.sh
```
### Part II

---

Installation [Kubernetes](https://kubernetes.io)software package. Here we use a third-party [mirror](https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/) station for installation

```shell
./k8s.sh
```

### Final Part

---

You can create or join a cluster using following command

```shell
#Create a new cluster
kubeadm init --image-repository  registry.cn-hangzhou.aliyuncs.com/mypjb --node-name $(hostname) --control-plane-endpoint $(hostname)  --v=5
```

