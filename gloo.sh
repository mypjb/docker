#!/bin/bash
set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb
image_version=1.9.1
curl -Lo glooctl https://github.com/solo-io/gloo/releases/download/v1.9.1/glooctl-linux-amd64
chmod 111 glooctl
mv glooctl  /usr/bin/
glooctl version

echo "Use the following command to install"

echo "glooctl install (gateway or ingress or knative)"

echo "Use the following command to pull the image in advance"

echo -e  "ctr -n k8s.io image pull ${image_url}/gloo-certgen:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-certgen:${image_version} quay.io/solo-io/certgen:${image_version}"

echo -e  "ctr -n k8s.io image pull ${image_url}/gloo-discovery:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-discovery:${image_version} quay.io/solo-io/discovery:${image_version}"

echo -e "ctr -n k8s.io image pull ${image_url}/gloo-gateway:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-gateway:${image_version} quay.io/solo-io/gateway:${image_version}"

echo -e  "ctr -n k8s.io image pull ${image_url}/gloo-envoy-wrapper:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-envoy-wrapper:${image_version} quay.io/solo-io/gloo-envoy-wrapper:${image_version}"

echo -e  "ctr -n k8s.io image pull ${image_url}/gloo:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo:${image_version} quay.io/solo-io/gloo:${image_version}"
