#!/bin/bash

# Build and run tests in Docker (non-parallel execution)
echo "Building Docker image and running tests on Linux (Ubuntu LTS) - Serial Execution..."

# Build the Docker image
docker-compose build shoper-webapi-tests

# Run the tests without parallel execution
docker-compose run --rm shoper-webapi-tests swift test --no-parallel

echo "Tests completed!"