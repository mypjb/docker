#!/bin/bash

bash_dir=$(cd $(dirname $0); pwd)
bash_dir=$bash_dir/mirror

mkdir -p $bash_dir

cd $bash_dir

k8s_dir=k8s

mkdir -p ${k8s_dir}

#k8s
echo FROM registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.9.1  > ${k8s_dir}/csi-node-driver-registrar
echo FROM registry.k8s.io/sig-storage/csi-resizer:v1.9.2  > ${k8s_dir}/csi-resizer
echo FROM registry.k8s.io/sig-storage/csi-provisioner:v3.6.2  > ${k8s_dir}/csi-provisioner
echo FROM registry.k8s.io/sig-storage/csi-snapshotter:v6.3.2 > ${k8s_dir}/csi-snapshotter
echo FROM registry.k8s.io/sig-storage/csi-attacher:v4.4.2  > ${k8s_dir}/csi-attacher
