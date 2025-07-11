#!/bin/bash

# Local development script for WebSphere Cafe with Liberty

set -e

echo "Starting WebSphere Cafe in Liberty dev mode..."

# Start PostgreSQL in Docker for local development
docker run -d --name postgres-cafe \
  -e POSTGRES_DB=cafedb \
  -e POSTGRES_USER=cafe \
  -e POSTGRES_PASSWORD=cafe123 \
  -p 5432:5432 \
  postgres:13 || echo "PostgreSQL container already running or exists"

echo "PostgreSQL started on localhost:5432"

# Set environment variables for local development
export DB_SERVER=localhost
export DB_PORT=5432
export DB_NAME=cafedb
export DB_USER=cafe
export DB_PASSWORD=cafe123

# Change to web module directory
cd websphere-cafe-web

# Start Liberty in dev mode
mvn liberty:dev

echo "Liberty dev mode started. Access application at http://localhost:9080/websphere-cafe"