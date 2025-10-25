ARG VARIANT="latest"
FROM docker.io/archlinux/archlinux:${VARIANT}

LABEL org.opencontainers.image.title="Arch Linux Base with Docker-outside-of-Docker and .NET"
LABEL org.opencontainers.image.source="https://github.com/zyrakq/arch-devcontainer-images"
LABEL org.opencontainers.image.description="Arch Linux base image with Docker-outside-of-Docker and .NET"
LABEL org.opencontainers.image.licenses="MIT OR Apache-2.0"

# Adjust directory permissions
RUN chmod 555 /srv/ftp && \
    chmod 755 /usr/share/polkit-1/rules.d/

# Initialize pacman keyring and upgrade system
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --needed --noconfirm --disable-download-timeout archlinux-keyring && \
    pacman -Su --noconfirm --disable-download-timeout
