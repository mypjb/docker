#!/bin/bash
set -o errexit

rook_namespace=${2:-"rook-ceph"}

rook_dir="rook"

rook_default_host="ceph.rook.lass.net"

rook_host=${1:-"${rook_default_host}"}

if kubectl get namespace $rook_namespace; then
    echo "命名空间已存在"
else
    kubectl create namespace $rook_namespace
    echo "命名空间已创建"
fi


sed -i "s/${rook_default_host}/${rook_host}/g" $rook_dir/cert.yaml

kubectl apply -f $rook_dir/cert.yaml

kubectl apply -f $rook_dir/crds.yaml -f $rook_dir/common.yaml -f $rook_dir/operator.yaml

if [ "${1}" == "dev" ];then
  echo "test environment use single node create cluster"
  kubectl apply -f $rook_dir/cluster-test.yaml
fi

if [ "${1}" == "prod" ];then
  kubectl apply -f $rook_dir/cluster.yaml
fi

echo "in $rook_dir 'cephfs' or 'rdb' folder. use 'kubectl apply -f storageclass.yaml' create storage class "
