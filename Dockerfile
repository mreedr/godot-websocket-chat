# Use the official slim Ubuntu image (smaller than full ubuntu:22.04)
FROM ubuntu:22.04

# Install only what we need
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download Godot 4.5.1 stable (linux x86_64) from the exact URL you provided
# Added --tries=5 and --retry-connrefused in case Railway's network is flaky
RUN wget -O godot.zip \
    --tries=5 \
    --retry-connrefused \
    --waitretry=5 \
    "https://downloads.godotengine.org/?version=4.5.1&flavor=stable&slug=linux.x86_64.zip&platform=linux.64" \
    && unzip godot.zip \
    && mv Godot_v4.5.1-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm godot.zip

# Copy your project files into the container
WORKDIR /app
COPY . .

# Railway injects $PORT automatically – fall back to 8000 if not set
ENV PORT=8000

# Expose the port (helps with docs, Railway ignores this anyway)
EXPOSE ${PORT}

# Run the server headless
CMD ["/usr/local/bin/godot", "--headless", "--main-pack", "/app/server/server.tscn"]