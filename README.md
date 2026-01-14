# 🐧 Arch Linux Dev Container Images

Pre-built Docker images for VS Code Dev Containers based on Arch Linux, organized into multiple image families with logical categorization.

## 📦 Image Families

### 🏠 arch-base Family

Minimal Arch Linux images without desktop environment.

| Image | Description | Registry |
|-------|-------------|----------|
| arch-base | Minimal Arch Linux without features | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base` |
| arch-base-common | Arch Linux with common-utils | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common` |
| arch-base-dind | Arch Linux with Docker-in-Docker | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind` |
| arch-base-dood | Arch Linux with Docker-outside-of-Docker | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood` |

### 🖥️ arch-webtop Families

Desktop environment images with web-based access. Each desktop environment has its own family with consistent structure.

#### Available Desktop Environments

- **arch-webtop-kasmvnc** - Optimized web desktop (KasmVNC)
- **arch-webtop-kde** - KDE Plasma desktop
- **arch-webtop-i3** - i3 tiling window manager
- **arch-webtop-mate** - MATE desktop
- **arch-webtop-xfce** - XFCE desktop

#### Image Structure (for each DE)

Each desktop environment family includes 4 images:

| Image | Description |
|-------|-------------|
| arch-webtop-{de} | Base desktop environment |
| arch-webtop-{de}-common | DE + common-utils |
| arch-webtop-{de}-dind | DE + Docker-in-Docker |
| arch-webtop-{de}-dood | DE + Docker-outside-of-Docker |

> **Note**: Replace `{de}` with: `kasmvnc`, `kde`, `i3`, `mate`, or `xfce`

#### Example Registry Paths

```sh
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-kde
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-kde-common
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-i3-dind
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-xfce-dood
```

## 🚀 Usage

### Basic Usage

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest"
}
```

### With Webtop (requires --shm-size)

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-kde:latest",
  "runArgs": ["--shm-size=1gb"]
}
```

### With Docker-outside-of-Docker

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood:latest",
  "mounts": [
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ]
}
```

### Adding Language Support

You can add language support to any image using devcontainer features:

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common:latest",
  "features": {
    "ghcr.io/zyrakq/arch-devcontainer-features/node:1": {
      "installYarn": true,
      "installPnpm": true
    },
    "ghcr.io/zyrakq/arch-devcontainer-features/rust:2": {}
  }
}
```

## 📁 Repository Structure

```sh
src/
├── arch-base/              # Minimal Arch Linux family (4 images)
│   ├── arch-base/         # Base image
│   ├── arch-base-common/  # Base + common-utils
│   ├── arch-base-dind/    # Base + Docker-in-Docker
│   └── arch-base-dood/    # Base + Docker-outside-of-Docker
├── arch-webtop-kasmvnc/   # KasmVNC desktop family (4 images)
├── arch-webtop-kde/       # KDE Plasma desktop family (4 images)
├── arch-webtop-i3/        # i3 window manager family (4 images)
├── arch-webtop-mate/      # MATE desktop family (4 images)
├── arch-webtop-xfce/      # XFCE desktop family (4 images)
└── arch-project/          # Project-specific images
```

**Total**: 24 images (4 base + 20 webtop)

## 🔧 Features Used

Features can be added to any base image to customize your environment:

| Feature | Source |
|---------|--------|
| common-utils | `ghcr.io/bartventer/arch-devcontainer-features/common-utils` |
| node | `ghcr.io/zyrakq/arch-devcontainer-features/node` |
| rust | `ghcr.io/zyrakq/arch-devcontainer-features/rust` |
| dotnet | `ghcr.io/zyrakq/arch-devcontainer-features/dotnet` |
| go | `ghcr.io/bartventer/arch-devcontainer-features/go` |
| docker-in-docker | `ghcr.io/bartventer/arch-devcontainer-features/docker-in-docker` |
| docker-outside-of-docker | `ghcr.io/bartventer/arch-devcontainer-features/docker-outside-of-docker` |

## 🔗 Related Projects

- 📁 **[arch-devcontainer-templates](https://github.com/zyrakq/arch-devcontainer-templates)** - Templates for creating Arch Linux development environments
- ⚙️ **[arch-devcontainer-features](https://github.com/zyrakq/arch-devcontainer-features)** - Dev Container features for Arch Linux
- 🌟 **[bartventer/devcontainer-images](https://github.com/bartventer/devcontainer-images)** - Project that inspired this repository

## 🔄 Push to Custom Registry

### Manual Image Push

You can manually push any built image from GitHub Container Registry to your custom registry using the **Push to Custom Registry** workflow.

#### Setup

1. Add the following secrets to your repository (Settings → Secrets and variables → Actions):
   - `CUSTOM_REGISTRY_URL` - Your registry URL (e.g., `registry.example.com`)
   - `CUSTOM_REGISTRY_USERNAME` - Username for authentication
   - `CUSTOM_REGISTRY_PASSWORD` - Password or token for authentication

#### Usage

1. Go to **Actions** → **Push to Custom Registry**
2. Click **Run workflow**
3. Fill in the parameters:
   - **Image name**: Name of the image to push (e.g., `arch-base-common`)
   - **Source tag**: Tag from GHCR (e.g., `latest` or `20241027.123`)
   - **Target tag**: Tag for custom registry (optional, defaults to source tag)
   - **Registry URL**: Override registry URL (optional, uses secret by default)
4. Click **Run workflow**

The workflow will:

- Pull the complete multi-arch image from GHCR
- Push it to your custom registry
- Verify the push was successful

#### Example

To push `arch-base-common:latest` to your registry:

```txt
Image name: arch-base-common
Source tag: latest
Target tag: (leave empty or specify custom tag)
Registry URL: (leave empty to use secret)
```

Result: `registry.example.com/arch-base-common:latest` (all platforms)

#### Benefits

- **Faster pulls**: Images cached in your local registry
- **Reduced latency**: No cross-border network delays
- **Selective sync**: Push only the images you need
- **Complete images**: Full multi-arch support preserved

## ⏰ Build & Maintenance

### Staged Build Schedule

Images are built weekly on **Wednesday** to optimize resource usage and leverage layer caching:

| Time (UTC) | Stage | Count | Base Image | Description |
|------------|-------|-------|------------|-------------|
| 00:00 | Base Images | 6 | upstream | Minimal base images from archlinux and linuxserver |
| 01:30 | Common Utils | 6 | *-base:latest | Base images with common-utils feature |
| 03:00 | Docker-in-Docker | 6 | *-common:latest | Images with DinD support |
| 04:30 | Docker-outside-of-Docker | 6 | *-common:latest | Images with DooD support |

**Total**: 24 images built every Wednesday over ~5 hours with maximum layer reuse

### Build Optimization

- ⚡ **Layer Reuse**: Each stage builds on previous stages' images
- 📦 **Reduced Redundancy**: Base system built once, reused in all derived images
- 🔄 **Distributed Load**: Build load spread across 4 time windows
- 💾 **Bandwidth Savings**: Significant reduction in bandwidth by not re-downloading base system
- 🎯 **Minimal Base**: Simplified structure with only essential images

### Maintenance

- 🧹 **Monthly Cleanup**: Old versions cleaned up on the 20th of each month (keeping last 3 versions)
- 🏷️ **Versioning**: Images tagged with both `latest` and `YYYYMMDD.{run_number}`
- 🔄 **Auto-discovery**: GitHub Actions automatically discover all images from `src/` directory
- 📊 **Workflow Chaining**: Each stage triggers after previous completes successfully

## 🎯 Design Principles

- **Family-based Organization**: Each base image type has its own family
- **Consistent Structure**: All families follow the same structure (base, common, dind, dood)
- **No Cache Builds**: Always use latest packages and features
- **Multi-platform**: Support for `linux/amd64` and `linux/arm64` (arch-base) or `linux/amd64` (arch-webtop)
- **Minimal Images**: Keep base images minimal, add features as needed
- **Flat Structure**: No nested subdirectories, simplified organization

## 📄 License

Dual-licensed under MIT OR Apache-2.0

**Note**: The LinuxServer.io Docker images used by arch-webtop families are licensed under GPL-3.0. When you use these images, the resulting container will be subject to GPL-3.0 terms. See [LinuxServer.io License](https://github.com/linuxserver/docker-webtop/blob/master/LICENSE) for details.
