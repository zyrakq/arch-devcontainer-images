#!/bin/bash

# Script to generate arch-webtop devcontainer image configurations
# Usage: ./scripts/generate-webtop-images.sh

set -e

# Webtop base images mapping
declare -A WEBTOP_BASES=(
    ["kasmvnc"]="ghcr.io/linuxserver/baseimage-kasmvnc:arch"
    ["kde"]="lscr.io/linuxserver/webtop:arch-kde"
    ["i3"]="lscr.io/linuxserver/webtop:arch-i3"
    ["mate"]="lscr.io/linuxserver/webtop:arch-mate"
    ["xfce"]="lscr.io/linuxserver/webtop:arch-xfce"
)

# Common feature configurations for webtop (username: abc)
COMMON_UTILS_WEBTOP='"ghcr.io/bartventer/arch-devcontainer-features/common-utils:1": {
      "username": "abc",
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

# Create Dockerfile for webtop base images
create_webtop_dockerfile() {
    local base_image="$1"
    local title="$2"
    local description="$3"
    local output="$4"
    
    cat > "$output" << EOF
FROM ${base_image}

LABEL org.opencontainers.image.title="${title}"
LABEL org.opencontainers.image.source="https://github.com/zyrakq/arch-devcontainer-images"
LABEL org.opencontainers.image.description="${description}"
LABEL org.opencontainers.image.licenses="MIT OR Apache-2.0"
EOF
}

# Create devcontainer.json for webtop (no features)
create_webtop_devcontainer_base() {
    local output="$1"
    
    cat > "$output" << 'EOF'
{
  "build": {
    "dockerfile": "./Dockerfile",
    "context": "."
  },
  "runArgs": [
    "--shm-size=1gb"
  ],
  "remoteUser": "abc",
  "remoteEnv": {
    "HOME": "/config"
  }
}
EOF
}

# Create devcontainer.json from image for webtop
create_webtop_devcontainer_from_image() {
    local base_image="$1"
    local features="$2"
    local output="$3"
    
    if [ -z "$features" ]; then
        # No additional features
        cat > "$output" << EOF
{
  "image": "${base_image}",
  "runArgs": [
    "--shm-size=1gb"
  ],
  "remoteUser": "abc",
  "remoteEnv": {
    "HOME": "/config"
  }
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
  "runArgs": [
    "--shm-size=1gb"
  ],
  "remoteUser": "abc",
  "remoteEnv": {
    "HOME": "/config"
  }
}
EOF
    fi
}

# Create metadata.json for webtop
create_webtop_metadata() {
    local name="$1"
    local description="$2"
    local output="$3"
    
    cat > "$output" << EOF
{
  "name": "$name",
  "description": "$description",
  "platforms": ["linux/amd64"],
  "registry": "ghcr.io",
  "repository": "zyrakq/arch-devcontainer-images"
}
EOF
}

# Generate images for each DE
for de in "${!WEBTOP_BASES[@]}"; do
    base_image="${WEBTOP_BASES[$de]}"
    echo "Generating arch-webtop-${de} images..."
    
    # ===== BASE IMAGE WITH DOCKERFILE =====
    
    # Base (no features) - uses Dockerfile
    mkdir -p "src/arch-webtop-${de}/base/arch-webtop-${de}/.devcontainer"
    create_webtop_dockerfile "$base_image" \
        "Arch Linux Webtop with ${de^^}" \
        "Arch Linux webtop image with ${de^^} desktop environment" \
        "src/arch-webtop-${de}/base/arch-webtop-${de}/.devcontainer/Dockerfile"
    create_webtop_devcontainer_base \
        "src/arch-webtop-${de}/base/arch-webtop-${de}/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}" \
        "Arch Linux webtop image with ${de^^} desktop environment" \
        "src/arch-webtop-${de}/base/arch-webtop-${de}/metadata.json"
    
    # Base image references for this DE
    WEBTOP_BASE="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}:latest"
    WEBTOP_COMMON="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-common:latest"
    WEBTOP_NODE="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-node:latest"
    WEBTOP_RUST="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-rust:latest"
    WEBTOP_GO="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-go:latest"
    WEBTOP_DOTNET="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-dotnet:latest"
    WEBTOP_NODE_RUST="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-node-rust:latest"
    WEBTOP_NODE_GO="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-node-go:latest"
    WEBTOP_NODE_DOTNET="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-node-dotnet:latest"
    
    # ===== BASE-COMMON IMAGE =====
    
    # Base with common-utils - FROM arch-webtop-{de}:latest
    mkdir -p "src/arch-webtop-${de}/base/arch-webtop-${de}-common/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_BASE" "$COMMON_UTILS_WEBTOP" \
        "src/arch-webtop-${de}/base/arch-webtop-${de}-common/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-common" \
        "Arch Linux webtop image with ${de^^} and common development tools" \
        "src/arch-webtop-${de}/base/arch-webtop-${de}-common/metadata.json"
    
    # ===== LANG IMAGES (FROM *-common) =====
    
    mkdir -p "src/arch-webtop-${de}/lang/arch-webtop-${de}-node/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${NODE_FEATURE}" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-node" \
        "Arch Linux webtop image with ${de^^} and Node.js" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/lang/arch-webtop-${de}-rust/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${RUST_FEATURE}" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-rust/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-rust" \
        "Arch Linux webtop image with ${de^^} and Rust" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-rust/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/lang/arch-webtop-${de}-go/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${GO_FEATURE}" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-go/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-go" \
        "Arch Linux webtop image with ${de^^} and Go" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-go/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/lang/arch-webtop-${de}-dotnet/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${DOTNET_FEATURE}" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-dotnet/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dotnet" \
        "Arch Linux webtop image with ${de^^} and .NET SDK" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-dotnet/metadata.json"
    
    # Node combinations (FROM *-node)
    mkdir -p "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-rust/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE" "${RUST_FEATURE}" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-rust/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-node-rust" \
        "Arch Linux webtop image with ${de^^}, Node.js and Rust for fullstack development" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-rust/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-go/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE" "${GO_FEATURE}" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-go/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-node-go" \
        "Arch Linux webtop image with ${de^^}, Node.js and Go for fullstack development" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-go/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-dotnet/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE" "${DOTNET_FEATURE}" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-dotnet/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-node-dotnet" \
        "Arch Linux webtop image with ${de^^}, Node.js and .NET for fullstack development" \
        "src/arch-webtop-${de}/lang/arch-webtop-${de}-node-dotnet/metadata.json"
    
    # ===== DIND IMAGES (FROM *-common or *-lang) =====
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind" \
        "Arch Linux webtop image with ${de^^} and Docker-in-Docker" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind-node" \
        "Arch Linux webtop image with ${de^^}, Docker-in-Docker and Node.js" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-rust/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_RUST" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-rust/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind-rust" \
        "Arch Linux webtop image with ${de^^}, Docker-in-Docker and Rust" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-rust/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-go/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_GO" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-go/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind-go" \
        "Arch Linux webtop image with ${de^^}, Docker-in-Docker and Go" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-go/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-dotnet/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_DOTNET" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-dotnet/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind-dotnet" \
        "Arch Linux webtop image with ${de^^}, Docker-in-Docker and .NET SDK" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-dotnet/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-rust/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE_RUST" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-rust/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind-node-rust" \
        "Arch Linux webtop image with ${de^^}, Docker-in-Docker, Node.js and Rust for fullstack development" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-rust/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-go/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE_GO" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-go/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind-node-go" \
        "Arch Linux webtop image with ${de^^}, Docker-in-Docker, Node.js and Go for fullstack development" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-go/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-dotnet/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE_DOTNET" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-dotnet/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind-node-dotnet" \
        "Arch Linux webtop image with ${de^^}, Docker-in-Docker, Node.js and .NET for fullstack development" \
        "src/arch-webtop-${de}/dind/arch-webtop-${de}-dind-node-dotnet/metadata.json"
    
    # ===== DOOD IMAGES (FROM *-common or *-lang) =====
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood" \
        "Arch Linux webtop image with ${de^^} and Docker-outside-of-Docker" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood-node" \
        "Arch Linux webtop image with ${de^^}, Docker-outside-of-Docker and Node.js" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-rust/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_RUST" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-rust/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood-rust" \
        "Arch Linux webtop image with ${de^^}, Docker-outside-of-Docker and Rust" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-rust/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-go/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_GO" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-go/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood-go" \
        "Arch Linux webtop image with ${de^^}, Docker-outside-of-Docker and Go" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-go/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-dotnet/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_DOTNET" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-dotnet/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood-dotnet" \
        "Arch Linux webtop image with ${de^^}, Docker-outside-of-Docker and .NET SDK" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-dotnet/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-rust/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE_RUST" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-rust/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood-node-rust" \
        "Arch Linux webtop image with ${de^^}, Docker-outside-of-Docker, Node.js and Rust for fullstack development" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-rust/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-go/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE_GO" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-go/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood-node-go" \
        "Arch Linux webtop image with ${de^^}, Docker-outside-of-Docker, Node.js and Go for fullstack development" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-go/metadata.json"
    
    mkdir -p "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-dotnet/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_NODE_DOTNET" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-dotnet/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood-node-dotnet" \
        "Arch Linux webtop image with ${de^^}, Docker-outside-of-Docker, Node.js and .NET for fullstack development" \
        "src/arch-webtop-${de}/dood/arch-webtop-${de}-dood-node-dotnet/metadata.json"
done

echo "All arch-webtop images generated successfully!"