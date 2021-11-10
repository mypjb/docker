#!/bin/bash

set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb
image_version=v1.10.5

curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}

sha256sum --check cilium-linux-amd64.tar.gz.sha256sum

tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin

rm cilium-linux-amd64.tar.gz{,.sha256sum}


echo "Use the following command to install"

echo "cilium install --agent-image ${image_url}/cilium:${image_version}  --operator-image ${image_url}/cilium-operator-generic:${image_version}"

