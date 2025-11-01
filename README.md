# DevBox OS 🐳

[![bluebuild build badge](https://github.com/ersintarhan/devbox-os/actions/workflows/build.yml/badge.svg)](https://github.com/ersintarhan/devbox-os/actions/workflows/build.yml)

**A container-first development environment built on Fedora Silverblue**

DevBox OS is a custom Fedora Silverblue image designed for developers who embrace the container-first philosophy. Built with [BlueBuild](https://blue-build.org/), it provides a minimal, immutable base system while leveraging distrobox for development tools.

## 🎯 Philosophy

- **Immutable Base**: Keep the base system minimal and clean
- **Container-First**: All development tools live in distrobox containers
- **Declarative**: Everything is defined in `recipe.yml`
- **Secure by Default**: Image signing with cosign, minimal attack surface

## ✨ Features

### 🖥️ Base System
- **Fedora Silverblue 43** with GNOME desktop
- Minimal package layering for performance
- Automatic daily builds and updates
- Signed images with cosign

### 📦 Included Tools
**Host System (Minimal):**
- Shells: `fish`, `zsh`
- Editor: `neovim`
- Multiplexer: `tmux`
- File Manager: `nautilus` (with extension development support)
- Containers: `distrobox`, `podman-compose`

**Development (via distrobox):**
- All development tools live in containers
- Export binaries to host with `distrobox-export`
- See distrobox setup below for details

**Virtualization:**
- KVM/QEMU with `libvirt`
- `virt-install` for VM management
- Auto-configured libvirt service

**Btrfs Snapshots:**
- `snapper` for /home snapshots
- Automatic snapshot management
- Easy rollback capabilities

**Multimedia:**
- Full codec support (H.264, H.265, AAC, x264, etc.)
- FFmpeg with all codecs
- GStreamer plugins (bad-freeworld, ugly, libav)
- RPM Fusion repositories

**AMD GPU Support:**
- Mesa Vulkan drivers for gaming/graphics
- ROCm OpenCL for compute workloads
- VA-API hardware video acceleration (freeworld drivers)
- VDPAU video decode acceleration
- vulkan-tools for debugging

**Fonts:**
- Fira Code, JetBrains Mono, Noto Emoji

### 📱 Default Flatpaks
**Browsers:**
- Brave
- Firefox
- Zen Browser

**Development:**
- VS Code

**Communication:**
- Telegram
- Thunderbird

**Multimedia:**
- VLC
- Spotify

**Utilities:**
- Flatseal (Flatpak permissions)
- Warehouse (Flatpak manager)
- GNOME Boxes (virtual machines)
- Extension Manager (GNOME extensions)

### 🐳 Distrobox Setup
Pre-configured distrobox environments:
- **dev-fedora**: Fedora Toolbox with common dev tools
- **dev-ubuntu**: Ubuntu-based development environment

Create with:
```bash
distrobox-assemble create
```

## 🚀 Installation

### Fresh Install

1. **Rebase to unsigned image** (first time):
   ```bash
   rpm-ostree rebase ostree-unverified-registry:ghcr.io/ersintarhan/devbox-os:latest
   sudo systemctl reboot
   ```

2. **Rebase to signed image** (after reboot):
   ```bash
   rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ersintarhan/devbox-os:latest
   sudo systemctl reboot
   ```

### Post-Install Setup

1. **Add user to libvirt group** (for KVM/VMs):
   ```bash
   sudo usermod -aG libvirt $USER
   # Logout and login for group changes to take effect
   ```

2. **Create distrobox containers:**
   ```bash
   distrobox-assemble create
   ```

3. **Enter development environment:**
   ```bash
   distrobox-enter dev-fedora
   ```

4. **Install development tools in container:**
   ```bash
   # Inside distrobox (dev-fedora)

   # Core development tools
   sudo dnf install -y git gh

   # Modern CLI tools
   sudo dnf install -y bat ripgrep fd-find eza zoxide git-delta btop

   # Export binaries to host (accessible everywhere)
   distrobox-export --bin /usr/bin/git
   distrobox-export --bin /usr/bin/gh
   distrobox-export --bin /usr/bin/bat
   distrobox-export --bin /usr/bin/rg  # ripgrep
   distrobox-export --bin /usr/bin/fd
   distrobox-export --bin /usr/bin/eza
   distrobox-export --bin /usr/bin/zoxide
   distrobox-export --bin /usr/bin/delta
   distrobox-export --bin /usr/bin/btop

   # Language runtimes (Node.js via Volta)
   curl https://get.volta.sh | bash
   volta install node@22

   # .NET SDK
   curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0
   curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 9.0
   ```

5. **Test KVM/virtualization:**
   ```bash
   virsh list --all
   # Or use GNOME Boxes GUI
   ```

6. **Enable automatic snapshots (optional):**
   ```bash
   sudo systemctl enable --now snapper-timeline.timer
   sudo systemctl enable --now snapper-cleanup.timer
   ```

7. **Manage snapshots:**
   ```bash
   # List snapshots
   sudo snapper -c home list

   # Create manual snapshot
   sudo snapper -c home create --description "Before update"

   # Rollback to previous snapshot
   sudo snapper -c home undochange 1..2
   ```

### Optional: Quake-Mode Terminal

For a dropdown terminal (F12), install **ddterm** GNOME extension:
- Open Extension Manager
- Search for "ddterm"
- Install and enable

## 🔄 Updates

DevBox OS automatically builds daily at 06:00 UTC. To update:

```bash
rpm-ostree upgrade
sudo systemctl reboot
```

## 🛠️ Customization

### Fork and Customize

1. Fork this repository
2. Edit `recipes/recipe.yml`
3. Push changes - GitHub Actions will build automatically
4. Rebase to your custom image:
   ```bash
   rpm-ostree rebase ostree-unverified-registry:ghcr.io/YOUR-USERNAME/devbox-os:latest
   ```

### Adding Packages

Edit `recipes/recipe.yml`:

```yaml
- type: dnf
  install:
    packages:
      - your-package-here
```

### Adding Flatpaks

```yaml
- type: default-flatpaks
  configurations:
    - scope: system
      install:
        - org.app.Name
```

## 📚 Documentation

- [BlueBuild Documentation](https://blue-build.org/)
- [Fedora Silverblue User Guide](https://docs.fedoraproject.org/en-US/fedora-silverblue/)
- [Distrobox Documentation](https://distrobox.it/)

## 🔐 Verification

Images are signed with cosign. Verify with:

```bash
cosign verify --key cosign.pub ghcr.io/ersintarhan/devbox-os:latest
```

## 🤝 Contributing

Contributions welcome! Please open an issue or PR.

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- Built with [BlueBuild](https://blue-build.org/)
- Based on [Fedora Silverblue](https://fedoraproject.org/silverblue/)
- Inspired by [Universal Blue](https://universal-blue.org/)

---

**DevBox OS** - Develop anywhere, deploy everywhere 🚀
