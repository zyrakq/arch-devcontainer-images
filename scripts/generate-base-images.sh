#!/bin/bash

# Script to generate devcontainer image configurations
# Usage: ./scripts/generate-base-images.sh

set -e

# Common feature configurations
PACMAN_MIRROR_FEATURE='"ghcr.io/zyrakq/arch-devcontainer-features/pacman-mirror:1": {
      "mode": "reflector"
    }'

COMMON_UTILS_FEATURE='"ghcr.io/bartventer/arch-devcontainer-features/common-utils:1": {
      "username": "vscode",
      "additionalPackages": "base-devel",
      "installZsh": true,
      "installOhMyZsh": true,
      "configureZshAsDefaultShell": true
    }'

DIND_FEATURE='"ghcr.io/bartventer/arch-devcontainer-features/docker-in-docker:1": {}'

DOOD_FEATURE='"ghcr.io/bartventer/arch-devcontainer-features/docker-outside-of-docker:1": {}'

# Create devcontainer.json with base image and features
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

echo "Generating arch-base images..."

# ===== 1. arch-base (base with Dockerfile) =====
mkdir -p src/arch-base/arch-base/.devcontainer
cat > "src/arch-base/arch-base/.devcontainer/Dockerfile" << 'EOF'
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

cat > "src/arch-base/arch-base/.devcontainer/devcontainer.json" << 'EOF'
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

create_metadata "arch-base" \
    "Minimal Arch Linux base image without pre-installed features" \
    "src/arch-base/arch-base/metadata.json"

# ===== 2. arch-base-common (FROM arch-base:latest + pacman-mirror + common-utils) =====
mkdir -p src/arch-base/arch-base-common/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base:latest" \
    "${PACMAN_MIRROR_FEATURE},
    ${COMMON_UTILS_FEATURE}" \
    "src/arch-base/arch-base-common/.devcontainer/devcontainer.json"

create_metadata "arch-base-common" \
    "Arch Linux base image with common development tools" \
    "src/arch-base/arch-base-common/metadata.json"

# ===== 3. arch-base-dind (FROM arch-base-common:latest + dind) =====
mkdir -p src/arch-base/arch-base-dind/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest" \
    "${DIND_FEATURE}" \
    "src/arch-base/arch-base-dind/.devcontainer/devcontainer.json"

create_metadata "arch-base-dind" \
    "Arch Linux base image with Docker-in-Docker support" \
    "src/arch-base/arch-base-dind/metadata.json"

# ===== 4. arch-base-dood (FROM arch-base-common:latest + dood) =====
mkdir -p src/arch-base/arch-base-dood/.devcontainer
create_devcontainer_from_image "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest" \
    "${DOOD_FEATURE}" \
    "src/arch-base/arch-base-dood/.devcontainer/devcontainer.json"

create_metadata "arch-base-dood" \
    "Arch Linux base image with Docker-outside-of-Docker support" \
    "src/arch-base/arch-base-dood/metadata.json"

echo "All arch-base images generated successfully!"
echo "Total: 4 images (base, common, dind, dood)"
BASE_COMMON_IMAGE="ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest"
