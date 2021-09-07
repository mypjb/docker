#!/bin/bash

bash_dir=$(cd $(dirname $0); pwd)

echo FROM k8s.gcr.io/kube-apiserver:v1.22.1 > kube-apiserver
echo FROM k8s.gcr.io/kube-controller-manager:v1.22.1 > kube-controller-manager
echo FROM k8s.gcr.io/kube-scheduler:v1.22.1 > kube-scheduler
echo FROM k8s.gcr.io/kube-proxy:v1.22.1 > kube-proxy
echo FROM k8s.gcr.io/pause:3.5 > pause
echo FROM k8s.gcr.io/etcd:3.5.0-0 > etcd
echo FROM k8s.gcr.io/coredns/coredns:v1.8.4 > coredns

