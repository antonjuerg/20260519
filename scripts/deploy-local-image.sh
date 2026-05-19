#!/usr/bin/env bash
set -euo pipefail

docker build -t sample-app:latest ./app
kind load docker-image sample-app:latest --name platform-assignment

echo "Local image built and loaded into kind"