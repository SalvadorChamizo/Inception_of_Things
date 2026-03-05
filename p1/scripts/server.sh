#!/bin/bash

# If any command fails, stop immediately
set -e

if ! command -v curl >/dev/null 2>&1; then
    apt update -y 
    apt install -y curl
fi

if ! systemctl is-active --quiet k3s; then
    curl -sfL https://get.k3s.io | sh -s - \
        --node-ip 192.168.56.110 \
        --disable traefik \
        --disable servicelb \
        --token=12345 \
        --write-kubeconfig-mode 644
fi