# Use official Swift Docker image based on Ubuntu LTS
FROM swift:6.0-jammy

# Set working directory
WORKDIR /workspace

# Install system dependencies if needed
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy Package.swift first for better Docker layer caching
COPY Package.swift .

# Resolve dependencies
RUN swift package resolve

# Copy source code
COPY Sources ./Sources
COPY Tests ./Tests

# Build the package
RUN swift build

# Default command to run tests
CMD ["swift", "test"]