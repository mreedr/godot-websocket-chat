# Use the official slim Ubuntu image (smaller than full ubuntu:22.04)
FROM ubuntu:22.04

# Install only what we need
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    unzip \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O godot.zip \
    "https://downloads.godotengine.org/?version=4.5.1&flavor=stable&slug=linux.x86_64.zip&platform=linux.64" \
    && unzip godot.zip \
    && mv Godot_v4.5.1-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm godot.zip

# Copy your project files into the container
WORKDIR /app
COPY . .

EXPOSE $PORT

# Run the server headless
CMD ["/usr/local/bin/godot", "--headless", "server.tscn"]