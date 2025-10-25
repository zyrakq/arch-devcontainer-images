#!/bin/bash

# Script to generate devcontainer image configurations
# Usage: ./scripts/generate-images.sh

set -e

# Common feature configurations
COMMON_UTILS_FEATURE='
    "ghcr.io/bartventer/arch-devcontainer-features/common-utils:1": {
      "username": "vscode",
      "additionalPackages": "base-devel",
      "installZsh": true,
      "installOhMyZsh": true,
      "configureZshAsDefaultShell": true
    }'

NODE_FEATURE='
    "ghcr.io/zyrakq/arch-devcontainer-features/node:1": {
      "installYarn": true,
      "installPnpm": true,
      "globalPackages": "typescript,nodemon"
    }'

RUST_FEATURE='
    "ghcr.io/zyrakq/arch-devcontainer-features/rust:1": {}'

GO_FEATURE='
    "ghcr.io/bartventer/arch-devcontainer-features/go:1": {}'

DOTNET_FEATURE='
    "ghcr.io/zyrakq/arch-devcontainer-features/dotnet:1": {
      "installAspNetRuntime": true,
      "installEntityFramework": true,
      "installGlobalTools": "dotnet-format,dotnet-outdated-tool"
    }'

DIND_FEATURE='
    "ghcr.io/bartventer/arch-devcontainer-features/docker-in-docker:1": {}'

DOOD_FEATURE='
    "ghcr.io/bartventer/arch-devcontainer-features/docker-outside-of-docker:1": {}'

# Base Dockerfile template
create_dockerfile() {
    local title="$1"
    local description="$2"
    
    cat > "$3" << 'EOF'
ARG VARIANT="latest"
FROM docker.io/archlinux/archlinux:${VARIANT}

LABEL org.opencontainers.image.title="TITLE_PLACEHOLDER"
LABEL org.opencontainers.image.source="https://github.com/zyrakq/arch-devcontainer-images"
LABEL org.opencontainers.image.description="DESCRIPTION_PLACEHOLDER"
LABEL org.opencontainers.image.licenses="MIT OR Apache-2.0"

# Adjust directory permissions
RUN chmod 555 /srv/ftp && \
    chmod 755 /usr/share/polkit-1/rules.d/

# Initialize pacman keyring and upgrade system
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --needed --noconfirm --disable-download-timeout archlinux-keyring && \
    pacman -Su --noconfirm --disable-download-timeout
EOF
    
    sed -i "s/TITLE_PLACEHOLDER/$title/" "$3"
    sed -i "s/DESCRIPTION_PLACEHOLDER/$description/" "$3"
}

# Create devcontainer.json
create_devcontainer() {
    local features="$1"
    local output="$2"
    
    cat > "$output" << EOF
{
  "build": {
    "dockerfile": "./Dockerfile",
    "context": ".",
    "args": {
      "VARIANT": "latest"
    }
  },
  "features": {${COMMON_UTILS_FEATURE}${features}
  },
  "remoteUser": "vscode"
}
EOF
}

# Create metadata.json
create_metadata() {
    local name="$1"
    local description="$2"
    local output="$3"
    
    cat > "$output" << EOF
{
  "name": "$name",
  "description": "$description",
  "platforms": ["linux/amd64", "linux/arm64"],
  "registry": "ghcr.io",
  "repository": "zyrakq/arch-devcontainer-images"
}
EOF
}

echo "Generating arch-base lang images..."

# Single language images
mkdir -p src/arch-base/lang/arch-base-node/.devcontainer
create_dockerfile "Arch Linux Base with Node.js" \
    "Arch Linux base image with Node.js LTS and common development tools" \
    "src/arch-base/lang/arch-base-node/.devcontainer/Dockerfile"
create_devcontainer ",${NODE_FEATURE}" \
    "src/arch-base/lang/arch-base-node/.devcontainer/devcontainer.json"
create_metadata "arch-base-node" \
    "Arch Linux base image with Node.js LTS and common development tools" \
    "src/arch-base/lang/arch-base-node/metadata.json"

mkdir -p src/arch-base/lang/arch-base-rust/.devcontainer
create_dockerfile "Arch Linux Base with Rust" \
    "Arch Linux base image with Rust and common development tools" \
    "src/arch-base/lang/arch-base-rust/.devcontainer/Dockerfile"
create_devcontainer ",${RUST_FEATURE}" \
    "src/arch-base/lang/arch-base-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-rust" \
    "Arch Linux base image with Rust and common development tools" \
    "src/arch-base/lang/arch-base-rust/metadata.json"

mkdir -p src/arch-base/lang/arch-base-go/.devcontainer
create_dockerfile "Arch Linux Base with Go" \
    "Arch Linux base image with Go and common development tools" \
    "src/arch-base/lang/arch-base-go/.devcontainer/Dockerfile"
create_devcontainer ",${GO_FEATURE}" \
    "src/arch-base/lang/arch-base-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-go" \
    "Arch Linux base image with Go and common development tools" \
    "src/arch-base/lang/arch-base-go/metadata.json"

mkdir -p src/arch-base/lang/arch-base-dotnet/.devcontainer
create_dockerfile "Arch Linux Base with .NET" \
    "Arch Linux base image with .NET SDK and common development tools" \
    "src/arch-base/lang/arch-base-dotnet/.devcontainer/Dockerfile"
create_devcontainer ",${DOTNET_FEATURE}" \
    "src/arch-base/lang/arch-base-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dotnet" \
    "Arch Linux base image with .NET SDK and common development tools" \
    "src/arch-base/lang/arch-base-dotnet/metadata.json"

# Node combinations
mkdir -p src/arch-base/lang/arch-base-node-rust/.devcontainer
create_dockerfile "Arch Linux Base with Node.js and Rust" \
    "Arch Linux base image with Node.js and Rust for fullstack development" \
    "src/arch-base/lang/arch-base-node-rust/.devcontainer/Dockerfile"
create_devcontainer ",${NODE_FEATURE},${RUST_FEATURE}" \
    "src/arch-base/lang/arch-base-node-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-node-rust" \
    "Arch Linux base image with Node.js and Rust for fullstack development" \
    "src/arch-base/lang/arch-base-node-rust/metadata.json"

mkdir -p src/arch-base/lang/arch-base-node-go/.devcontainer
create_dockerfile "Arch Linux Base with Node.js and Go" \
    "Arch Linux base image with Node.js and Go for fullstack development" \
    "src/arch-base/lang/arch-base-node-go/.devcontainer/Dockerfile"
create_devcontainer ",${NODE_FEATURE},${GO_FEATURE}" \
    "src/arch-base/lang/arch-base-node-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-node-go" \
    "Arch Linux base image with Node.js and Go for fullstack development" \
    "src/arch-base/lang/arch-base-node-go/metadata.json"

mkdir -p src/arch-base/lang/arch-base-node-dotnet/.devcontainer
create_dockerfile "Arch Linux Base with Node.js and .NET" \
    "Arch Linux base image with Node.js and .NET for fullstack development" \
    "src/arch-base/lang/arch-base-node-dotnet/.devcontainer/Dockerfile"
create_devcontainer ",${NODE_FEATURE},${DOTNET_FEATURE}" \
    "src/arch-base/lang/arch-base-node-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-node-dotnet" \
    "Arch Linux base image with Node.js and .NET for fullstack development" \
    "src/arch-base/lang/arch-base-node-dotnet/metadata.json"

echo "Generating arch-base dind images..."

# DinD base
mkdir -p src/arch-base/dind/arch-base-dind/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker" \
    "Arch Linux base image with Docker-in-Docker support" \
    "src/arch-base/dind/arch-base-dind/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind" \
    "Arch Linux base image with Docker-in-Docker support" \
    "src/arch-base/dind/arch-base-dind/metadata.json"

# DinD + single languages
mkdir -p src/arch-base/dind/arch-base-dind-node/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker and Node.js" \
    "Arch Linux base image with Docker-in-Docker and Node.js" \
    "src/arch-base/dind/arch-base-dind-node/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE},${NODE_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node" \
    "Arch Linux base image with Docker-in-Docker and Node.js" \
    "src/arch-base/dind/arch-base-dind-node/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-rust/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker and Rust" \
    "Arch Linux base image with Docker-in-Docker and Rust" \
    "src/arch-base/dind/arch-base-dind-rust/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE},${RUST_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-rust" \
    "Arch Linux base image with Docker-in-Docker and Rust" \
    "src/arch-base/dind/arch-base-dind-rust/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-go/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker and Go" \
    "Arch Linux base image with Docker-in-Docker and Go" \
    "src/arch-base/dind/arch-base-dind-go/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE},${GO_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-go" \
    "Arch Linux base image with Docker-in-Docker and Go" \
    "src/arch-base/dind/arch-base-dind-go/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-dotnet/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker and .NET" \
    "Arch Linux base image with Docker-in-Docker and .NET" \
    "src/arch-base/dind/arch-base-dind-dotnet/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE},${DOTNET_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-dotnet" \
    "Arch Linux base image with Docker-in-Docker and .NET SDK" \
    "src/arch-base/dind/arch-base-dind-dotnet/metadata.json"

# DinD + Node combinations
mkdir -p src/arch-base/dind/arch-base-dind-node-rust/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker, Node.js and Rust" \
    "Arch Linux base image with Docker-in-Docker, Node.js and Rust" \
    "src/arch-base/dind/arch-base-dind-node-rust/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE},${NODE_FEATURE},${RUST_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node-rust" \
    "Arch Linux base image with Docker-in-Docker, Node.js and Rust for fullstack development" \
    "src/arch-base/dind/arch-base-dind-node-rust/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-node-go/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker, Node.js and Go" \
    "Arch Linux base image with Docker-in-Docker, Node.js and Go" \
    "src/arch-base/dind/arch-base-dind-node-go/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE},${NODE_FEATURE},${GO_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node-go" \
    "Arch Linux base image with Docker-in-Docker, Node.js and Go for fullstack development" \
    "src/arch-base/dind/arch-base-dind-node-go/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-node-dotnet/.devcontainer
create_dockerfile "Arch Linux Base with Docker-in-Docker, Node.js and .NET" \
    "Arch Linux base image with Docker-in-Docker, Node.js and .NET" \
    "src/arch-base/dind/arch-base-dind-node-dotnet/.devcontainer/Dockerfile"
create_devcontainer ",${DIND_FEATURE},${NODE_FEATURE},${DOTNET_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node-dotnet" \
    "Arch Linux base image with Docker-in-Docker, Node.js and .NET for fullstack development" \
    "src/arch-base/dind/arch-base-dind-node-dotnet/metadata.json"

echo "Generating arch-base dood images..."

# DooD base
mkdir -p src/arch-base/dood/arch-base-dood/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker" \
    "Arch Linux base image with Docker-outside-of-Docker support" \
    "src/arch-base/dood/arch-base-dood/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood" \
    "Arch Linux base image with Docker-outside-of-Docker support" \
    "src/arch-base/dood/arch-base-dood/metadata.json"

# DooD + single languages
mkdir -p src/arch-base/dood/arch-base-dood-node/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker and Node.js" \
    "Arch Linux base image with Docker-outside-of-Docker and Node.js" \
    "src/arch-base/dood/arch-base-dood-node/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE},${NODE_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node" \
    "Arch Linux base image with Docker-outside-of-Docker and Node.js" \
    "src/arch-base/dood/arch-base-dood-node/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-rust/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker and Rust" \
    "Arch Linux base image with Docker-outside-of-Docker and Rust" \
    "src/arch-base/dood/arch-base-dood-rust/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE},${RUST_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-rust" \
    "Arch Linux base image with Docker-outside-of-Docker and Rust" \
    "src/arch-base/dood/arch-base-dood-rust/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-go/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker and Go" \
    "Arch Linux base image with Docker-outside-of-Docker and Go" \
    "src/arch-base/dood/arch-base-dood-go/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE},${GO_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-go" \
    "Arch Linux base image with Docker-outside-of-Docker and Go" \
    "src/arch-base/dood/arch-base-dood-go/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-dotnet/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker and .NET" \
    "Arch Linux base image with Docker-outside-of-Docker and .NET" \
    "src/arch-base/dood/arch-base-dood-dotnet/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE},${DOTNET_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-dotnet" \
    "Arch Linux base image with Docker-outside-of-Docker and .NET SDK" \
    "src/arch-base/dood/arch-base-dood-dotnet/metadata.json"

# DooD + Node combinations
mkdir -p src/arch-base/dood/arch-base-dood-node-rust/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker, Node.js and Rust" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and Rust" \
    "src/arch-base/dood/arch-base-dood-node-rust/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE},${NODE_FEATURE},${RUST_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node-rust" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and Rust for fullstack development" \
    "src/arch-base/dood/arch-base-dood-node-rust/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-node-go/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker, Node.js and Go" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and Go" \
    "src/arch-base/dood/arch-base-dood-node-go/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE},${NODE_FEATURE},${GO_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node-go" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and Go for fullstack development" \
    "src/arch-base/dood/arch-base-dood-node-go/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-node-dotnet/.devcontainer
create_dockerfile "Arch Linux Base with Docker-outside-of-Docker, Node.js and .NET" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and .NET" \
    "src/arch-base/dood/arch-base-dood-node-dotnet/.devcontainer/Dockerfile"
create_devcontainer ",${DOOD_FEATURE},${NODE_FEATURE},${DOTNET_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node-dotnet" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and .NET for fullstack development" \
    "src/arch-base/dood/arch-base-dood-node-dotnet/metadata.json"

echo "All arch-base images generated successfully!"