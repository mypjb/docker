#!/bin/bash
set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb
k8s_np=k8s.io

image_commands[0]="ctr -n ${k8s_np} image pull ${image_url}/sig-storage-csi-snapshotter:v4.2.0 && ctr -n ${k8s_np} image tag ${k8s_np}/sig-storage/csi-snapshotter:v4.2.0"

image_commands[1]="ctr -n ${k8s_np} image pull ${image_url}/sig-storage-csi-node-driver-registrar:v2.3.0 && ctr -n ${k8s_np} image tag ${k8s_np}/sig-storage/csi-node-driver-registrar:v2.3.0"

image_commands[2]="ctr -n ${k8s_np} image pull ${image_url}/sig-storage-csi-resizer:v1.3.0 && ctr -n ${k8s_np} image tag ${k8s_np}/sig-storage/csi-resizer:v1.3.0"

image_commands[3]="ctr -n ${k8s_np} image pull ${image_url}/sig-storage-csi-provisioner:v3.0.0 && ctr -n ${k8s_np} image tag ${k8s_np}/sig-storage/csi-provisioner:v3.0.0"

image_commands[4]="ctr -n ${k8s_np} image pull ${image_url}/sig-storage-csi-attacher:v3.3.0 && ctr -n ${k8s_np} image tag ${k8s_np}/sig-storage/csi-attacher:v3.3.0"

if [ "${1}" == "pull" ];then

	echo "pull images"
	
	for image_command in "${image_commands[@]}";do
		$image_command
	done	
fi

