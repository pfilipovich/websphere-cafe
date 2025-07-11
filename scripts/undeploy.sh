#!/bin/bash

# Undeployment script for WebSphere Cafe on Kubernetes

set -e

echo "Removing WebSphere Cafe from Kubernetes..."

# Delete Kubernetes resources
kubectl delete -f k8s/app-deployment.yaml --ignore-not-found=true
kubectl delete -f k8s/postgres-deployment.yaml --ignore-not-found=true
kubectl delete -f k8s/secret.yaml --ignore-not-found=true
kubectl delete -f k8s/configmap.yaml --ignore-not-found=true
kubectl delete -f k8s/namespace.yaml --ignore-not-found=true

echo "Undeployment completed successfully!"