#!/bin/bash

bash_dir=$(cd $(dirname $0); pwd)
bash_dir=$bash_dir/docker

cd $bash_dir
gloo_version=1.11.0

gloo_dir=gloo

mkdir -p ${gloo_dir}

#gloo
echo FROM quay.io/solo-io/certgen:${gloo_version} > ${gloo_dir}/certgen
echo FROM quay.io/solo-io/discovery:${gloo_version} > ${gloo_dir}/discovery
echo FROM quay.io/solo-io/gloo-envoy-wrapper:${gloo_version} > ${gloo_dir}/gloo-envoy-wrapper
echo FROM quay.io/solo-io/gateway:${gloo_version} > ${gloo_dir}/gateway
echo FROM quay.io/solo-io/gloo:${gloo_version} > ${gloo_dir}/gloo


