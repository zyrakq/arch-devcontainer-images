#!/bin/bash

# Script to generate devcontainer image configurations
# Usage: ./scripts/generate-base-images.sh

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

NODE_FEATURE='"ghcr.io/zyrakq/arch-devcontainer-features/node:1": {
      "installYarn": true,
      "installPnpm": true,
      "globalPackages": "typescript,nodemon"
    }'

RUST_FEATURE='"ghcr.io/zyrakq/arch-devcontainer-features/rust:1": {}'

GO_FEATURE='"ghcr.io/bartventer/arch-devcontainer-features/go:1": {}'

DOTNET_FEATURE='"ghcr.io/zyrakq/arch-devcontainer-features/dotnet:1": {
      "installAspNetRuntime": true,
      "installEntityFramework": true,
      "installGlobalTools": "dotnet-format,dotnet-outdated-tool"
    }'

DIND_FEATURE='"ghcr.io/bartventer/arch-devcontainer-features/docker-in-docker:1": {}'

DOOD_FEATURE='"ghcr.io/bartventer/arch-devcontainer-features/docker-outside-of-docker:1": {}'

# Create devcontainer.json with base image
create_devcontainer_from_image() {
    local base_image="$1"
    local features="$2"
    local output="$3"
    
    if [ -z "$features" ]; then
        # No additional features
        cat > "$output" << EOF
{
  "image": "${base_image}",
  "remoteUser": "vscode"
}
EOF
    else
        # With additional features
        cat > "$output" << EOF
{
  "image": "${base_image}",
  "features": {
    ${features}
  },
  "remoteUser": "vscode"
}
EOF
    fi
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

echo "Generating arch-base base images..."

# arch-base (no features) - uses Dockerfile
mkdir -p src/arch-base/base/arch-base/.devcontainer
cat > "src/arch-base/base/arch-base/.devcontainer/Dockerfile" << 'EOF'
ARG VARIANT="latest"
FROM docker.io/archlinux/archlinux:${VARIANT}

LABEL org.opencontainers.image.title="Arch Linux Base"
LABEL org.opencontainers.image.source="https://github.com/zyrakq/arch-devcontainer-images"
LABEL org.opencontainers.image.description="Minimal Arch Linux base image for Dev Containers"
LABEL org.opencontainers.image.licenses="MIT OR Apache-2.0"
LABEL org.opencontainers.image.authors="Zyrakq <serg.shehov@tutanota.com>"

# Adjust directory permissions
RUN chmod 555 /srv/ftp && \
    chmod 755 /usr/share/polkit-1/rules.d/

# Initialize pacman keyring and upgrade system
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --needed --noconfirm --disable-download-timeout archlinux-keyring && \
    pacman -Su --noconfirm --disable-download-timeout
EOF

cat > "src/arch-base/base/arch-base/.devcontainer/devcontainer.json" << 'EOF'
{
  "build": {
    "dockerfile": "./Dockerfile",
    "context": ".",
    "args": {
      "VARIANT": "latest"
    }
  },
  "remoteUser": "vscode"
}
EOF

# arch-base-common (FROM arch-base:latest) - uses image
mkdir -p src/arch-base/base/arch-base-common/.devcontainer
cat > "src/arch-base/base/arch-base-common/.devcontainer/devcontainer.json" << 'EOF'
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base:latest",
  "features": {
    "ghcr.io/bartventer/arch-devcontainer-features/common-utils:1": {
      "username": "vscode",
      "additionalPackages": "base-devel",
      "installZsh": true,
      "installOhMyZsh": true,
      "configureZshAsDefaultShell": true
    }
  },
  "remoteUser": "vscode"
}
EOF

echo "Generating arch-base lang images..."

# Single language images (FROM arch-base-common:latest)
BASE_COMMON_IMAGE="ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest"

mkdir -p src/arch-base/lang/arch-base-node/.devcontainer
create_devcontainer_from_image "$BASE_COMMON_IMAGE" "${NODE_FEATURE}" \
    "src/arch-base/lang/arch-base-node/.devcontainer/devcontainer.json"
create_metadata "arch-base-node" \
    "Arch Linux base image with Node.js LTS and common development tools" \
    "src/arch-base/lang/arch-base-node/metadata.json"

mkdir -p src/arch-base/lang/arch-base-rust/.devcontainer
create_devcontainer_from_image "$BASE_COMMON_IMAGE" "${RUST_FEATURE}" \
    "src/arch-base/lang/arch-base-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-rust" \
    "Arch Linux base image with Rust and common development tools" \
    "src/arch-base/lang/arch-base-rust/metadata.json"

mkdir -p src/arch-base/lang/arch-base-go/.devcontainer
create_devcontainer_from_image "$BASE_COMMON_IMAGE" "${GO_FEATURE}" \
    "src/arch-base/lang/arch-base-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-go" \
    "Arch Linux base image with Go and common development tools" \
    "src/arch-base/lang/arch-base-go/metadata.json"

mkdir -p src/arch-base/lang/arch-base-dotnet/.devcontainer
create_devcontainer_from_image "$BASE_COMMON_IMAGE" "${DOTNET_FEATURE}" \
    "src/arch-base/lang/arch-base-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dotnet" \
    "Arch Linux base image with .NET SDK and common development tools" \
    "src/arch-base/lang/arch-base-dotnet/metadata.json"

# Node combinations (FROM arch-base-node:latest)
BASE_NODE_IMAGE="ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node:latest"
BASE_GO_IMAGE="ghcr.io/zyrakq/arch-devcontainer-images/arch-base-go:latest"

mkdir -p src/arch-base/lang/arch-base-node-rust/.devcontainer
create_devcontainer_from_image "$BASE_NODE_IMAGE" "${RUST_FEATURE}" \
    "src/arch-base/lang/arch-base-node-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-node-rust" \
    "Arch Linux base image with Node.js and Rust for fullstack development" \
    "src/arch-base/lang/arch-base-node-rust/metadata.json"

mkdir -p src/arch-base/lang/arch-base-node-go/.devcontainer
create_devcontainer_from_image "$BASE_GO_IMAGE" "${NODE_FEATURE}" \
    "src/arch-base/lang/arch-base-node-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-node-go" \
    "Arch Linux base image with Node.js and Go for fullstack development" \
    "src/arch-base/lang/arch-base-node-go/metadata.json"

mkdir -p src/arch-base/lang/arch-base-node-dotnet/.devcontainer
create_devcontainer_from_image "$BASE_NODE_IMAGE" "${DOTNET_FEATURE}" \
    "src/arch-base/lang/arch-base-node-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-node-dotnet" \
    "Arch Linux base image with Node.js and .NET for fullstack development" \
    "src/arch-base/lang/arch-base-node-dotnet/metadata.json"

echo "Generating arch-base dind images..."

# DinD images use lang images as base
mkdir -p src/arch-base/dind/arch-base-dind/.devcontainer
create_devcontainer_from_image "$BASE_COMMON_IMAGE" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind" \
    "Arch Linux base image with Docker-in-Docker support" \
    "src/arch-base/dind/arch-base-dind/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-node/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node:latest" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node" \
    "Arch Linux base image with Docker-in-Docker and Node.js" \
    "src/arch-base/dind/arch-base-dind-node/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-rust/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-rust:latest" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-rust" \
    "Arch Linux base image with Docker-in-Docker and Rust" \
    "src/arch-base/dind/arch-base-dind-rust/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-go/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-go:latest" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-go" \
    "Arch Linux base image with Docker-in-Docker and Go" \
    "src/arch-base/dind/arch-base-dind-go/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-dotnet/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dotnet:latest" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-dotnet" \
    "Arch Linux base image with Docker-in-Docker and .NET SDK" \
    "src/arch-base/dind/arch-base-dind-dotnet/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-node-rust/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-rust:latest" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node-rust" \
    "Arch Linux base image with Docker-in-Docker, Node.js and Rust for fullstack development" \
    "src/arch-base/dind/arch-base-dind-node-rust/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-node-go/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-go:latest" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node-go" \
    "Arch Linux base image with Docker-in-Docker, Node.js and Go for fullstack development" \
    "src/arch-base/dind/arch-base-dind-node-go/metadata.json"

mkdir -p src/arch-base/dind/arch-base-dind-node-dotnet/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-dotnet:latest" "${DIND_FEATURE}" \
    "src/arch-base/dind/arch-base-dind-node-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dind-node-dotnet" \
    "Arch Linux base image with Docker-in-Docker, Node.js and .NET for fullstack development" \
    "src/arch-base/dind/arch-base-dind-node-dotnet/metadata.json"

echo "Generating arch-base dood images..."

# DooD images use lang images as base
mkdir -p src/arch-base/dood/arch-base-dood/.devcontainer
create_devcontainer_from_image "$BASE_COMMON_IMAGE" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood" \
    "Arch Linux base image with Docker-outside-of-Docker support" \
    "src/arch-base/dood/arch-base-dood/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-node/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node:latest" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node" \
    "Arch Linux base image with Docker-outside-of-Docker and Node.js" \
    "src/arch-base/dood/arch-base-dood-node/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-rust/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-rust:latest" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-rust" \
    "Arch Linux base image with Docker-outside-of-Docker and Rust" \
    "src/arch-base/dood/arch-base-dood-rust/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-go/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-go:latest" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-go" \
    "Arch Linux base image with Docker-outside-of-Docker and Go" \
    "src/arch-base/dood/arch-base-dood-go/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-dotnet/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dotnet:latest" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-dotnet" \
    "Arch Linux base image with Docker-outside-of-Docker and .NET SDK" \
    "src/arch-base/dood/arch-base-dood-dotnet/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-node-rust/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-rust:latest" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node-rust/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node-rust" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and Rust for fullstack development" \
    "src/arch-base/dood/arch-base-dood-node-rust/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-node-go/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-go:latest" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node-go/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node-go" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and Go for fullstack development" \
    "src/arch-base/dood/arch-base-dood-node-go/metadata.json"

mkdir -p src/arch-base/dood/arch-base-dood-node-dotnet/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-dotnet:latest" "${DOOD_FEATURE}" \
    "src/arch-base/dood/arch-base-dood-node-dotnet/.devcontainer/devcontainer.json"
create_metadata "arch-base-dood-node-dotnet" \
    "Arch Linux base image with Docker-outside-of-Docker, Node.js and .NET for fullstack development" \
    "src/arch-base/dood/arch-base-dood-node-dotnet/metadata.json"

echo "All arch-base images generated successfully!"