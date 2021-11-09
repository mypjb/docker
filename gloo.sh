#!/bin/bash
set -o errexit

curl -Lo glooctl https://github.com/solo-io/gloo/releases/download/v1.9.1/glooctl-linux-amd64
chmod 111 glooctl
mv glooctl  /usr/bin/
glooctl version
glooctl install gateway
