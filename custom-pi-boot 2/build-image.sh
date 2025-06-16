#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG="$1"
LOOP=$(sudo losetup --show -fP "$IMG")

MNT_BOOT=$(mktemp -d)
MNT_ROOT=$(mktemp -d)

sudo mount "${LOOP}p1" "$MNT_BOOT"
sudo mount "${LOOP}p2" "$MNT_ROOT"

# Copy custom files from script directory
sudo cp -r "$SCRIPT_DIR/config/boot/"* "$MNT_BOOT/"
sudo cp -r "$SCRIPT_DIR/config/etc/"* "$MNT_ROOT/etc/"
sudo cp -r "$SCRIPT_DIR/config/home/pi/"* "$MNT_ROOT/home/pi/"
sudo chmod +x "$MNT_ROOT/etc/rc.local"
sudo chmod +x "$MNT_ROOT/home/pi/ebike_demo"

sudo umount "$MNT_BOOT"
sudo umount "$MNT_ROOT"
sudo losetup -d "$LOOP"
