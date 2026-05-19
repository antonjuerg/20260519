#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="platform-assignment"

if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "kind cluster '${CLUSTER_NAME}' already exists"
else
  kind create cluster --name "${CLUSTER_NAME}"
fi

kubectl cluster-info --context "kind-${CLUSTER_NAME}"

kubectl create namespace app --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace devops --dry-run=client -o yaml | kubectl apply -f -

echo "kind cluster is ready"