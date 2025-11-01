#!/usr/bin/env bash
# DevBox OS - Snapper Setup Script
# Configures snapper for /home btrfs subvolume

set -euo pipefail

echo "📸 DevBox OS - Configuring Snapper..."

# Check if /home is btrfs
if ! findmnt -n -o FSTYPE /home 2>/dev/null | grep -q btrfs; then
    echo "⚠️  /home is not btrfs, skipping snapper setup"
    exit 0
fi

echo "✅ /home is btrfs"

# Check if snapper config already exists
if [ -f /etc/snapper/configs/home ]; then
    echo "✅ Snapper already configured for /home"
    exit 0
fi

# Create snapper config for /home
echo "Creating snapper config for /home..."
snapper -c home create-config /home

# Configure snapper settings for /home
cat > /etc/snapper/configs/home << 'EOF'
# subvolume to snapshot
SUBVOLUME="/home"

# filesystem type
FSTYPE="btrfs"

# btrfs qgroup for space aware cleanup algorithms
QGROUP=""

# fraction or absolute size of the filesystems space the snapshots may use
SPACE_LIMIT="0.5"

# fraction or absolute size of the filesystems space that should be free
FREE_LIMIT="0.2"

# users and groups allowed to work with config
ALLOW_USERS=""
ALLOW_GROUPS=""

# sync users and groups from ALLOW_USERS and ALLOW_GROUPS to .snapshots
# directory
SYNC_ACL="no"

# start comparing pre- and post-snapshot in background after creating
# post-snapshot
BACKGROUND_COMPARISON="yes"

# run daily number cleanup
NUMBER_CLEANUP="yes"

# limit for number cleanup
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="10"
NUMBER_LIMIT_IMPORTANT="10"

# create hourly snapshots
TIMELINE_CREATE="yes"

# cleanup hourly snapshots after some time
TIMELINE_CLEANUP="yes"

# limits for timeline cleanup
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="10"
TIMELINE_LIMIT_DAILY="10"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"

# cleanup empty pre-post-pairs
EMPTY_PRE_POST_CLEANUP="yes"

# limits for empty pre-post-pair cleanup
EMPTY_PRE_POST_MIN_AGE="1800"
EOF

echo "✅ Snapper configured for /home"
echo "   - Hourly snapshots enabled"
echo "   - Keep last 10 snapshots"
echo "   - Using 50% max disk space"

# Don't enable timers here, let user decide
echo ""
echo "To enable automatic snapshots:"
echo "  sudo systemctl enable --now snapper-timeline.timer"
echo "  sudo systemctl enable --now snapper-cleanup.timer"
