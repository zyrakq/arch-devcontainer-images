# 🛠️ Arch Linux Base with Common Utils

Arch Linux base image with common development tools pre-installed via the common-utils feature.

## 📋 Description

This image provides a ready-to-use Arch Linux development environment with:

- 👤 Non-root user `vscode` with sudo access
- 🐚 Zsh with Oh My Zsh configuration
- 🔧 Base development tools (base-devel package group)
- 🧰 Common utilities for development

## 🚀 Usage

### In devcontainer.json

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest",
  "remoteUser": "vscode"
}
```

### With version tag

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:20250124.1",
  "remoteUser": "vscode"
}
```

## 🖥️ Platforms

- 🐧 linux/amd64
- 🐧 linux/arm64

## 🎯 Pre-installed Features

- **common-utils**: Provides non-root user, sudo, zsh, oh-my-zsh, and base-devel packages

## 🎨 Customization

You can add additional features or packages:

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest",
  "features": {
    "ghcr.io/bartventer/arch-devcontainer-features/docker-outside-of-docker:1": {}
  },
  "remoteUser": "vscode"
}
```

## 🔗 Related Projects

- 📁 **[arch-devcontainer-templates](https://github.com/zyrakq/arch-devcontainer-templates)** - Templates for creating Arch Linux development environments
- ⚙️ **[arch-devcontainer-features](https://github.com/zyrakq/arch-devcontainer-features)** - Dev Container features for Arch Linux
- 🌟 **[bartventer/devcontainer-images](https://github.com/bartventer/devcontainer-images)** - Project that inspired this repository

## 📄 License

Dual-licensed under MIT OR Apache-2.0
