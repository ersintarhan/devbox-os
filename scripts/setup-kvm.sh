#!/usr/bin/env bash
# DevBox OS - KVM/Libvirt Setup Script
# Configures libvirt for non-root users

set -euo pipefail

echo "🖥️  DevBox OS - Configuring KVM/libvirt..."

# Ensure libvirt group exists
getent group libvirt > /dev/null || groupadd -r libvirt

# Configure libvirt to allow non-root users
# This allows users in the libvirt group to manage VMs without sudo
cat > /etc/polkit-1/rules.d/50-libvirt.rules << 'EOF'
/* Allow users in libvirt group to manage VMs without password */
polkit.addRule(function(action, subject) {
    if (action.id == "org.libvirt.unix.manage" &&
        subject.isInGroup("libvirt")) {
            return polkit.Result.YES;
    }
});
EOF

echo "✅ KVM/libvirt configured successfully"
echo "   Users need to be in 'libvirt' group: sudo usermod -aG libvirt \$USER"
echo "   Then logout/login for group changes to take effect"
echo "   Test with: virsh list --all"
