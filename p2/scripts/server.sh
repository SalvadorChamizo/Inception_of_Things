#!/bin/bash

set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
    apt-get update -y 
    apt-get install -y curl
fi

if ! command -v k3s >/dev/null 2>&1; then
    curl -sfL https://get.k3s.io | sh -s - \
        --node-ip 192.168.56.110 \
        --token=12345 \
        --write-kubeconfig-mode 644
fi

echo "[INFO] Waiting for Kubernetes API..."

until kubectl get nodes --no-headers 2>/dev/null | grep -q .; do
    sleep 3
done

kubectl wait --for=condition=Ready node --all --timeout 120s

echo "[INFO] Cluster ready"

echo "[INFO] Applying app1 deployment"
kubectl apply -f /tmp/confs/app1-deployment.yaml

echo "[INFO] Applying app1 service"
kubectl apply -f /tmp/confs/app1-service.yaml

echo "[INFO] Applying app2 deployment"
kubectl apply -f /tmp/confs/app2-deployment.yaml

echo "[INFO] Applying app2 service"
kubectl apply -f /tmp/confs/app2-service.yaml

echo "[INFO] Applying app3 deployment"
kubectl apply -f /tmp/confs/app3-deployment.yaml

echo "[INFO] Applying app3 service"
kubectl apply -f /tmp/confs/app3-service.yaml

echo "[INFO] Applying ingress"
kubectl apply -f /tmp/confs/ingress.yaml