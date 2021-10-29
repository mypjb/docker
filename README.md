# kubernetes Install

[Kubernetes](https://kubernetes.io) installation is divided into tow parts

### Part I 

----

Installation [Kubernetes](https://kubernetes.io)software package. Here we use a third-party [mirror](https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/pool/) station for installation

```shell
./k8s.sh
```

### Part II

---

The script installs [containerd]((https://github.com/containerd/containerd)) and configures it as the runtime of the [Kubernetes](https://kubernetes.io) container

```shell
./cri.sh
```

