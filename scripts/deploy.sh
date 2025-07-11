#!/bin/bash

# Deployment script for WebSphere Cafe on Kubernetes

set -e

echo "Deploying WebSphere Cafe to Kubernetes..."

# Apply Kubernetes manifests
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/postgres-deployment.yaml
kubectl apply -f k8s/app-deployment.yaml

echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n websphere-cafe --timeout=300s
kubectl wait --for=condition=ready pod -l app=websphere-cafe -n websphere-cafe --timeout=300s

echo "Deployment completed successfully!"
echo ""
echo "To access the application:"
echo "1. Port forward: kubectl port-forward svc/websphere-cafe-service 8080:80 -n websphere-cafe"
echo "2. Access: http://localhost:8080/websphere-cafe"
echo ""
echo "Or configure your ingress controller and access via: http://websphere-cafe.local"