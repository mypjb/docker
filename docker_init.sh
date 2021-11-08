#!/bin/bash

bash_dir=$(cd $(dirname $0); pwd)
bash_dir=$bash_dir/docker

k8s_version=v1.22.1

cd $bash_dir

echo FROM k8s.gcr.io/kube-apiserver:${k8s_version} > kube-apiserver
echo FROM k8s.gcr.io/kube-controller-manager:${k8s_version} > kube-controller-manager
echo FROM k8s.gcr.io/kube-scheduler:${k8s_version} > kube-scheduler
echo FROM k8s.gcr.io/kube-proxy:${k8s_version} > kube-proxy
echo FROM k8s.gcr.io/pause:3.5 > pause
echo FROM k8s.gcr.io/etcd:3.5.0-0 > etcd
echo FROM k8s.gcr.io/coredns/coredns:v1.8.4 > coredns
echo FROM docker.io/kubernetesui/dashboard:v2.4.0 > dashboard
echo FROM docker.io/kubernetesui/metrics-scraper:v1.0.7 > metrics-scraper
echo FROM quay.io/solo-io/certgen:1.9.1 > certgen
