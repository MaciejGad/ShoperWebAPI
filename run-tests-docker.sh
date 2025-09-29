#!/bin/bash

# Build and run tests in Docker
echo "Building Docker image and running tests on Linux (Ubuntu LTS)..."

# Build the Docker image
docker-compose build shoper-webapi-tests

# Run the tests
docker-compose run --rm shoper-webapi-tests

echo "Tests completed!"