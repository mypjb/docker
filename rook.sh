#!/bin/bash
set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb
ctr_ns=k8s.io
k8s_ns=k8s.gcr.io

image_commands[0]="ctr -n ${ctr_ns} image pull ${image_url}/sig-storage-csi-snapshotter:v4.2.0 && ctr -n ${ctr_ns} image tag  ${image_url}/sig-storage-csi-snapshotter:v4.2.0 ${k8s_ns}/sig-storage/csi-snapshotter:v4.2.0"

image_commands[1]="ctr -n ${ctr_ns} image pull ${image_url}/sig-storage-csi-node-driver-registrar:v2.3.0 && ctr -n ${ctr_ns} image tag  ${image_url}/sig-storage-csi-node-driver-registrar:v2.3.0 ${k8s_ns}/sig-storage/csi-node-driver-registrar:v2.3.0"

image_commands[2]="ctr -n ${ctr_ns} image pull ${image_url}/sig-storage-csi-resizer:v1.3.0 && ctr -n ${ctr_ns} image tag ${image_url}/sig-storage-csi-resizer:v1.3.0 ${k8s_ns}/sig-storage/csi-resizer:v1.3.0"

image_commands[3]="ctr -n ${ctr_ns} image pull ${image_url}/sig-storage-csi-provisioner:v3.0.0 && ctr -n ${ctr_ns} image tag ${image_url}/sig-storage-csi-provisioner:v3.0.0 ${k8s_ns}/sig-storage/csi-provisioner:v3.0.0"

image_commands[4]="ctr -n ${ctr_ns} image pull ${image_url}/sig-storage-csi-attacher:v3.3.0 && ctr -n ${ctr_ns} image tag  ${image_url}/sig-storage-csi-attacher:v3.3.0 ${k8s_ns}/sig-storage/csi-attacher:v3.3.0"

image_commands[5]="ctr -n ${ctr_ns} image pull ${image_url}/ceph:v16.2.6 && ctr -n ${ctr_ns} image tag  ${image_url}/ceph:v16.2.6 quay.io/ceph/ceph:v16.2.6"

image_commands[6]="ctr -n ${ctr_ns} image pull ${image_url}/cephcsi:v3.4.0 && ctr -n ${ctr_ns} image tag  ${image_url}/cephcsi:v3.4.0 quay.io/cephcsi/cephcsi:v3.4.0"

if [ "${1}" == "pull" ];then

	echo "pull images"
	
	for image_command in "${image_commands[@]}";do
		bash -c "$image_command"
	done	
fi

