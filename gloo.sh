#!/bin/bash

curl -Lso https://github.com/solo-io/gloo/releases/download/v1.9.1/glooctl-linux-amd64 glooctl
chmod 111 glooctl
mv glooctl  /usr/bin/
glooctl version
glooctl install gateway
