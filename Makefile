.PHONY: test test-docker build clean help

# Default target
help:
	@echo "Available targets:"
	@echo "  test        - Run tests locally with Swift"
	@echo "  test-docker - Run tests in Docker container (Linux/Ubuntu LTS)"
	@echo "  build       - Build the project locally"
	@echo "  build-docker- Build Docker image"
	@echo "  clean       - Clean build artifacts"
	@echo "  shell-docker- Run interactive shell in Docker container"

# Local testing
test:
	swift test

# Docker testing
test-docker:
	docker-compose run --rm shoper-webapi-tests

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