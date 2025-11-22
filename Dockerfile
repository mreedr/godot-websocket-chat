FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Godot 4.3 stable (update GODOT_VERSION if using a newer release)
# ENV GODOT_VERSION="4.5-stable"
# RUN wget "https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.x86_64.zip" \
#     && unzip "Godot_v${GODOT_VERSION}_linux.x86_64.zip" \
#     && mv "Godot_v${GODOT_VERSION}_linux.x86_64" /usr/local/bin/godot \
#     && rm "Godot_v${GODOT_VERSION}_linux.x86_64.zip" \
#     && chmod +x /usr/local/bin/godot

RUN wget https://downloads.godotengine.org/?version=4.5.1&flavor=stable&slug=linux.x86_64.zip&platform=linux.64 \
    && unzip index.html?version=4.5.1&flavor=stable&slug=linux.x86_64.zip&platform=linux.64 \
    && mv Godot_v4.5.1-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot

# Copy project files
WORKDIR /app
COPY . .

# Copy pre-downloaded Godot binary
COPY Godot_v4.5-stable_linux.x86_64 /usr/local/bin/godot
RUN chmod +x /usr/local/bin/godot

# Expose the default port (Railway will proxy dynamically)
EXPOSE 8000

# Run the server in headless mode
CMD ["/usr/local/bin/godot", "--headless", "--scene", "server/server.tscn"]