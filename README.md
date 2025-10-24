# 🐧 Arch Linux Dev Container Images

Pre-built Docker images for VS Code Dev Containers based on Arch Linux.

## 📦 Available Images

| Image | Description | Registry |
|-------|-------------|----------|
| 🏠 arch-base | Minimal Arch Linux without features | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base` |
| 🛠️ arch-base-common | Arch Linux with common-utils pre-installed | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common` |

## 🚀 Usage

These images are designed to be used with [arch-devcontainer-templates](https://github.com/zyrakq/arch-devcontainer-templates).

### In devcontainer.json

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base:latest"
}
```

## 🔗 Related Projects

- 📁 **[arch-devcontainer-templates](https://github.com/zyrakq/arch-devcontainer-templates)** - Templates for creating Arch Linux development environments
- ⚙️ **[arch-devcontainer-features](https://github.com/zyrakq/arch-devcontainer-features)** - Dev Container features for Arch Linux
- 🌟 **[bartventer/devcontainer-images](https://github.com/bartventer/devcontainer-images)** - Project that inspired this repository

## ⏰ Build Schedule

- 📅 Images are built daily at 00:00 UTC
- 🧹 Old versions are cleaned up weekly (keeping last 10 versions)

## 📄 License

Dual-licensed under MIT OR Apache-2.0
