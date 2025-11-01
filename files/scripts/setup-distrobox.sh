#!/usr/bin/env bash
# DevBox OS - Distrobox Setup Script
# This script sets up default distrobox containers for development

set -euo pipefail

echo "🔧 DevBox OS - Setting up distrobox configuration..."

# Create distrobox config directory
mkdir -p /etc/distrobox

# Create distrobox.ini for automatic container creation
cat > /etc/distrobox/distrobox.ini << 'EOF'
# DevBox OS Default Distroboxes
# Users can create these containers with: distrobox-assemble create

[dev-fedora]
image=registry.fedoraproject.org/fedora-toolbox:latest
init=true
nvidia=false
pull=true
root=false
additional_packages="fish neovim git gcc make cmake"

[dev-ubuntu]
image=docker.io/library/ubuntu:latest
init=true
nvidia=false
pull=true
root=false
additional_packages="fish neovim git build-essential"
EOF

echo "✅ Distrobox configuration created at /etc/distrobox/distrobox.ini"
echo "   Users can create containers with: distrobox-assemble create"
