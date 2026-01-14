# 🏠 Arch Linux Base Image

Minimal Arch Linux base image for Dev Containers without any pre-installed features.

## 📋 Description

This image provides a clean Arch Linux environment with only the essential system setup:

- 🔑 Initialized pacman keyring
- 📦 Updated system packages
- 🔒 Proper directory permissions

## 🚀 Usage

### In devcontainer.json

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base:latest"
}
```

### With version tag

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base:20250124.1"
}
```

## 🖥️ Platforms

- 🐧 linux/amd64
- 🐧 linux/arm64

## 🎨 Customization

This is a minimal base image. You can add features or install packages as needed:

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base:latest",
  "features": {
    "ghcr.io/bartventer/arch-devcontainer-features/common-utils:1": {}
  }
}
```

## 🔗 Related Projects

- 📁 **[arch-devcontainer-templates](https://github.com/zyrakq/arch-devcontainer-templates)** - Templates for creating Arch Linux development environments
- ⚙️ **[arch-devcontainer-features](https://github.com/zyrakq/arch-devcontainer-features)** - Dev Container features for Arch Linux
- 🌟 **[bartventer/devcontainer-images](https://github.com/bartventer/devcontainer-images)** - Project that inspired this repository

## 📄 License

Dual-licensed under MIT OR Apache-2.0
