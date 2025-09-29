.PHONY: test test-docker build clean help

# Default target
help:
	@echo "Available targets:"
	@echo "  test         - Run tests locally with Swift"
	@echo "  test-serial  - Run tests locally without parallel execution"
	@echo "  test-docker  - Run tests in Docker container (Linux/Ubuntu LTS)"
	@echo "  test-docker-serial - Run tests in Docker without parallel execution"
	@echo "  build        - Build the project locally"
	@echo "  build-docker - Build Docker image"
	@echo "  clean        - Clean build artifacts"
	@echo "  shell-docker - Run interactive shell in Docker container"

# Local testing
test:
	swift test

# Local testing (non-parallel)
test-serial:
	swift test --no-parallel

# Docker testing
test-docker:
	docker-compose run --rm shoper-webapi-tests

# Docker testing (non-parallel)
test-docker-serial:
	docker-compose run --rm shoper-webapi-tests swift test --no-parallel

# Local build
build:
	swift build

# Docker build
build-docker:
	docker-compose build shoper-webapi-tests

# Clean build artifacts
clean:
	swift package clean
	rm -rf .build

# Interactive Docker shell for development
shell-docker:
	docker-compose run --rm shoper-webapi-dev