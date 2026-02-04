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
PACMAN_MIRROR_FEATURE='"ghcr.io/zyrakq/arch-devcontainer-features/pacman-mirror:1": {
      "mode": "reflector"
    }'

COMMON_UTILS_WEBTOP='"ghcr.io/bartventer/arch-devcontainer-features/common-utils:1": {
      "username": "abc",
      "additionalPackages": "base-devel",
      "installZsh": true,
      "installOhMyZsh": true,
      "configureZshAsDefaultShell": true
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
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.authors="Zyrakq <serg.shehov@tutanota.com>"
EOF
}

# Create devcontainer.json for webtop (base with Dockerfile)
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
    
    # Base image references for this DE
    WEBTOP_BASE="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}:latest"
    WEBTOP_COMMON="ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-${de}-common:latest"
    
    # ===== 1. arch-webtop-{de} (base with Dockerfile) =====
    mkdir -p "src/arch-webtop-${de}/arch-webtop-${de}/.devcontainer"
    create_webtop_dockerfile "$base_image" \
        "Arch Linux Webtop with ${de^^}" \
        "Arch Linux webtop image with ${de^^} desktop environment" \
        "src/arch-webtop-${de}/arch-webtop-${de}/.devcontainer/Dockerfile"
    create_webtop_devcontainer_base \
        "src/arch-webtop-${de}/arch-webtop-${de}/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}" \
        "Arch Linux webtop image with ${de^^} desktop environment" \
        "src/arch-webtop-${de}/arch-webtop-${de}/metadata.json"
    
    # ===== 2. arch-webtop-{de}-common (FROM arch-webtop-{de}:latest + pacman-mirror + common-utils) =====
    mkdir -p "src/arch-webtop-${de}/arch-webtop-${de}-common/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_BASE" "${PACMAN_MIRROR_FEATURE},
    ${COMMON_UTILS_WEBTOP}" \
        "src/arch-webtop-${de}/arch-webtop-${de}-common/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-common" \
        "Arch Linux webtop image with ${de^^} and common development tools" \
        "src/arch-webtop-${de}/arch-webtop-${de}-common/metadata.json"
    
    # ===== 3. arch-webtop-{de}-dind (FROM arch-webtop-{de}-common:latest + dind) =====
    mkdir -p "src/arch-webtop-${de}/arch-webtop-${de}-dind/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${DIND_FEATURE}" \
        "src/arch-webtop-${de}/arch-webtop-${de}-dind/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dind" \
        "Arch Linux webtop image with ${de^^} and Docker-in-Docker" \
        "src/arch-webtop-${de}/arch-webtop-${de}-dind/metadata.json"
    
    # ===== 4. arch-webtop-{de}-dood (FROM arch-webtop-{de}-common:latest + dood) =====
    mkdir -p "src/arch-webtop-${de}/arch-webtop-${de}-dood/.devcontainer"
    create_webtop_devcontainer_from_image "$WEBTOP_COMMON" "${DOOD_FEATURE}" \
        "src/arch-webtop-${de}/arch-webtop-${de}-dood/.devcontainer/devcontainer.json"
    create_webtop_metadata "arch-webtop-${de}-dood" \
        "Arch Linux webtop image with ${de^^} and Docker-outside-of-Docker" \
        "src/arch-webtop-${de}/arch-webtop-${de}-dood/metadata.json"
done

echo "All arch-webtop images generated successfully!"
echo "Total: 20 images (5 DEs × 4 images each)"
