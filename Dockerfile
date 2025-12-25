FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set version as an argument
ARG VERSION=2.0.0

# Download the pre-built binary from GitHub Releases
RUN curl -L -o raps.tar.gz "https://github.com/dmytro-yemelianov/raps/releases/download/v${VERSION}/raps-linux-x64.tar.gz" && \
    tar -xzf raps.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/raps && \
    rm raps.tar.gz

# Set the entrypoint
ENTRYPOINT ["raps"]
