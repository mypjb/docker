#!/bin/bash

bash_dir=$(cd $(dirname $0); pwd)
bash_dir=$bash_dir/docker

cd $bash_dir

k8s_version=v1.23.5
cilium_version=v1.11.3
gloo_version=1.11.0

k8s_dir=k8s
k8s_dashboard_dir=kubernetesui_dashboard
cilium_dir=cilium
gloo_dir=gloo

mkdir -p ${k8s_dir} ${k8s_dashboard_dir} ${cilium_dir} ${gloo_dir}

#k8s
echo FROM k8s.gcr.io/kube-apiserver:${k8s_version} > ${k8s_dir}/kube-apiserver
echo FROM k8s.gcr.io/kube-controller-manager:${k8s_version} > ${k8s_dir}/kube-controller-manager
echo FROM k8s.gcr.io/kube-scheduler:${k8s_version} > ${k8s_dir}/kube-scheduler
echo FROM k8s.gcr.io/kube-proxy:${k8s_version} > ${k8s_dir}/kube-proxy
echo FROM k8s.gcr.io/pause:3.6 > ${k8s_dir}/pause
echo FROM k8s.gcr.io/etcd:3.5.1-0 > ${k8s_dir}/etcd
echo FROM k8s.gcr.io/coredns/coredns:v1.8.6 > ${k8s_dir}/coredns
# k8s sig-storage
echo FROM k8s.gcr.io/sig-storage/csi-snapshotter:v4.2.0 > ${k8s_dir}/csi-snapshotter
echo FROM k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.3.0  > ${k8s_dir}/csi-node-driver-registrar
echo FROM k8s.gcr.io/sig-storage/csi-resizer:v1.3.0  > ${k8s_dir}/csi-resizer
echo FROM k8s.gcr.io/sig-storage/csi-provisioner:v3.0.0  > ${k8s_dir}/csi-provisioner
echo FROM k8s.gcr.io/sig-storage/csi-attacher:v3.3.0  > ${k8s_dir}/csi-attacher

# k8s rbac
echo FROM gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0  > ${k8s_dir}/kube-rbac-proxy

#dashboard
echo FROM docker.io/kubernetesui/dashboard:v2.4.0 > ${k8s_dashboard_dir}/dashboard
echo FROM docker.io/kubernetesui/metrics-scraper:v1.0.7 > ${k8s_dashboard_dir}/metrics-scraper
#cilium
echo FROM quay.io/cilium/cilium:${cilium_version} > ${cilium_dir}/cilium
echo FROM quay.io/cilium/operator-generic:${cilium_version} > ${cilium_dir}/operator-generic
#gloo
echo FROM quay.io/solo-io/certgen:${gloo_version} > ${gloo_dir}/certgen
echo FROM quay.io/solo-io/discovery:${gloo_version} > ${gloo_dir}/discovery
echo FROM quay.io/solo-io/gloo-envoy-wrapper:${gloo_version} > ${gloo_dir}/gloo-envoy-wrapper
echo FROM quay.io/solo-io/gateway:${gloo_version} > ${gloo_dir}/gateway
echo FROM quay.io/solo-io/gloo:${gloo_version} > ${gloo_dir}/gloo

#rook




