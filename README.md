# 🐧 Arch Linux Dev Container Images

Pre-built Docker images for VS Code Dev Containers based on Arch Linux, organized into multiple image families with logical categorization.

## 📦 Image Families

### 🏠 arch-base Family

Minimal Arch Linux images without desktop environment.

#### Base Images

| Image | Description | Registry |
|-------|-------------|----------|
| arch-base | Minimal Arch Linux without features | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base` |
| arch-base-common | Arch Linux with common-utils | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-common` |

#### Language Images

| Image | Languages | Registry |
|-------|-----------|----------|
| arch-base-node | Node.js LTS (yarn, pnpm, typescript, nodemon) | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node` |
| arch-base-rust | Rust stable | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-rust` |
| arch-base-go | Go latest | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-go` |
| arch-base-dotnet | .NET SDK (ASP.NET, EF, tools) | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dotnet` |
| arch-base-node-rust | Node.js + Rust | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-rust` |
| arch-base-node-go | Node.js + Go | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-go` |
| arch-base-node-dotnet | Node.js + .NET | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node-dotnet` |

#### Docker-in-Docker Images

| Image | Features | Registry |
|-------|----------|----------|
| arch-base-dind | Docker-in-Docker | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind` |
| arch-base-dind-node | DinD + Node.js | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind-node` |
| arch-base-dind-rust | DinD + Rust | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind-rust` |
| arch-base-dind-go | DinD + Go | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind-go` |
| arch-base-dind-dotnet | DinD + .NET | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind-dotnet` |
| arch-base-dind-node-rust | DinD + Node.js + Rust | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind-node-rust` |
| arch-base-dind-node-go | DinD + Node.js + Go | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind-node-go` |
| arch-base-dind-node-dotnet | DinD + Node.js + .NET | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dind-node-dotnet` |

#### Docker-outside-of-Docker Images

| Image | Features | Registry |
|-------|----------|----------|
| arch-base-dood | Docker-outside-of-Docker | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood` |
| arch-base-dood-node | DooD + Node.js | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-node` |
| arch-base-dood-rust | DooD + Rust | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-rust` |
| arch-base-dood-go | DooD + Go | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-go` |
| arch-base-dood-dotnet | DooD + .NET | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-dotnet` |
| arch-base-dood-node-rust | DooD + Node.js + Rust | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-node-rust` |
| arch-base-dood-node-go | DooD + Node.js + Go | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-node-go` |
| arch-base-dood-node-dotnet | DooD + Node.js + .NET | `ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-node-dotnet` |

### 🖥️ arch-webtop Families

Desktop environment images with web-based access. Each desktop environment has its own family with consistent structure.

#### Available Desktop Environments

- **arch-webtop-kasmvnc** - Optimized web desktop (KasmVNC)
- **arch-webtop-kde** - KDE Plasma desktop
- **arch-webtop-i3** - i3 tiling window manager
- **arch-webtop-mate** - MATE desktop
- **arch-webtop-xfce** - XFCE desktop

#### Image Categories (for each DE)

Each desktop environment family includes:

##### Webtop Base (2 images)

- `arch-webtop-{de}` - Base desktop environment
- `arch-webtop-{de}-common` - DE + common-utils

##### Webtop with Languages (7 images)

- `arch-webtop-{de}-node` - DE + Node.js (yarn, pnpm, typescript, nodemon)
- `arch-webtop-{de}-rust` - DE + Rust
- `arch-webtop-{de}-go` - DE + Go
- `arch-webtop-{de}-dotnet` - DE + .NET (ASP.NET, EF, tools)
- `arch-webtop-{de}-node-rust` - DE + Node.js + Rust
- `arch-webtop-{de}-node-go` - DE + Node.js + Go
- `arch-webtop-{de}-node-dotnet` - DE + Node.js + .NET

##### Webtop with Docker-in-Docker (8 images)

- `arch-webtop-{de}-dind` - DE + DinD
- `arch-webtop-{de}-dind-node` - DE + DinD + Node.js
- `arch-webtop-{de}-dind-rust` - DE + DinD + Rust
- `arch-webtop-{de}-dind-go` - DE + DinD + Go
- `arch-webtop-{de}-dind-dotnet` - DE + DinD + .NET
- `arch-webtop-{de}-dind-node-rust` - DE + DinD + Node.js + Rust
- `arch-webtop-{de}-dind-node-go` - DE + DinD + Node.js + Go
- `arch-webtop-{de}-dind-node-dotnet` - DE + DinD + Node.js + .NET

##### Webtop with Docker-outside-of-Docker (8 images)

- `arch-webtop-{de}-dood` - DE + DooD
- `arch-webtop-{de}-dood-node` - DE + DooD + Node.js
- `arch-webtop-{de}-dood-rust` - DE + DooD + Rust
- `arch-webtop-{de}-dood-go` - DE + DooD + Go
- `arch-webtop-{de}-dood-dotnet` - DE + DooD + .NET
- `arch-webtop-{de}-dood-node-rust` - DE + DooD + Node.js + Rust
- `arch-webtop-{de}-dood-node-go` - DE + DooD + Node.js + Go
- `arch-webtop-{de}-dood-node-dotnet` - DE + DooD + Node.js + .NET

> **Note**: Replace `{de}` with: `kasmvnc`, `kde`, `i3`, `mate`, or `xfce`
>
> **Total per DE**: 25 images (2 base + 7 lang + 8 dind + 8 dood)

#### Example Registry Paths

```sh
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-kde
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-kde-node
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-i3-dind
ghcr.io/zyrakq/arch-devcontainer-images/arch-webtop-xfce-dood-node
```

## 🚀 Usage

### Basic Usage

```json
{
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-node:latest"
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
  "image": "ghcr.io/zyrakq/arch-devcontainer-images/arch-base-dood-node:latest",
  "mounts": [
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ]
}
```

## 📁 Repository Structure

```sh
src/
├── arch-base/              # Minimal Arch Linux family
│   ├── base/              # Base images
│   ├── lang/              # Language-specific images
│   ├── dind/              # Docker-in-Docker variants
│   ├── dood/              # Docker-outside-of-Docker variants
│   └── specialized/       # Specialized images
├── arch-webtop-kasmvnc/   # KasmVNC desktop family
├── arch-webtop-kde/       # KDE Plasma desktop family
├── arch-webtop-i3/        # i3 window manager family
├── arch-webtop-mate/      # MATE desktop family
├── arch-webtop-xfce/      # XFCE desktop family
└── arch-project/          # Project-specific images
```

## 🔧 Features Used

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

## ⏰ Build & Maintenance

### Staged Build Schedule

Images are built in stages to optimize resource usage and leverage layer caching:

| Time (UTC) | Stage | Count | Base Image | Description |
|------------|-------|-------|------------|-------------|
| 00:00 | Base | 6 | upstream | Minimal base images from archlinux and linuxserver |
| 01:30 | Base Common | 6 | *-base:latest | Base images with common-utils feature |
| 03:00 | Languages | 56 | *-common:latest | Single language images (node, rust, go, dotnet) |
| 04:30 | Combinations | 30 | *-node:latest | Multi-language combinations (node-rust, node-go, node-dotnet) |
| 06:00 | Docker-in-Docker | 52 | *-common/*-lang | Images with DinD support |
| 09:00 | Docker-outside | 52 | *-common/*-lang | Images with DooD support |

**Total**: 150 images built over ~9 hours with maximum layer reuse

### Build Optimization

- ⚡ **Layer Reuse**: Each stage builds on previous stages' images
- 📦 **Reduced Redundancy**: Base system built once, reused 144 times
- 🔄 **Distributed Load**: Build load spread across 6 time windows
- 💾 **Bandwidth Savings**: ~69GB saved by not re-downloading base system

### Maintenance

- 🧹 **Weekly Cleanup**: Old versions cleaned up every Sunday (keeping last 3 versions)
- 🏷️ **Versioning**: Images tagged with both `latest` and `YYYYMMDD.{run_number}`
- 🔄 **Auto-discovery**: GitHub Actions automatically discover all images from `src/` directory
- 📊 **Workflow Chaining**: Each stage triggers after previous completes successfully

## 🎯 Design Principles

- **Family-based Organization**: Each base image type has its own family
- **Consistent Structure**: All families follow the same category structure
- **No Cache Builds**: Always use latest packages and features
- **Multi-platform**: Support for `linux/amd64` and `linux/arm64`
- **Minimal Combinations**: Only Node.js combinations to avoid bloat

## 📄 License

Dual-licensed under MIT OR Apache-2.0
