#!/bin/bash

# Build script for WebSphere Cafe on OpenLiberty

set -e

echo "Building WebSphere Cafe for OpenLiberty..."

# Clean and build the application
mvn clean package

echo "Building Docker image..."
docker build -t websphere-cafe:latest .

echo "Build completed successfully!"
echo "Docker image: websphere-cafe:latest"