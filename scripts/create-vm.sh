#!/bin/bash
# ============================================================
# Lutiek OS 2026 — Create Development VM
# ============================================================
# Requirements:
#   - QEMU/KVM installed
#   - User in libvirt group
#   - Ubuntu ISO downloaded
#   - 50GB free space on external drive
# ============================================================

set -e

VM_NAME="lutiek-os-dev"
ISO_PATH="/media/tiekavr/LutiekBackup/vm-images/ubuntu-24.04-desktop.iso"
DISK_PATH="/media/tiekavr/LutiekBackup/vm-images/lutiek-os-dev.qcow2"
RAM_MB=4096
CPUS=2

echo "=== Creating Lutiek OS Development VM ==="
echo "VM Name: $VM_NAME"
echo "ISO: $ISO_PATH"
echo "Disk: $DISK_PATH"
echo ""

# Check ISO exists
if [ ! -f "$ISO_PATH" ]; then
  echo "ERROR: ISO not found. Run the download first."
  exit 1
fi

ISO_SIZE=$(stat -c%s "$ISO_PATH")
EXPECTED=6655619072
if [ "$ISO_SIZE" -lt "$EXPECTED" ]; then
  echo "ERROR: ISO is incomplete ($((ISO_SIZE/1024/1024))MB / $((EXPECTED/1024/1024))MB)"
  exit 1
fi

# Verify ISO
if ! file "$ISO_PATH" | grep -q "ISO 9660"; then
  echo "ERROR: $ISO_PATH is not a valid ISO file"
  exit 1
fi

echo "ISO verified: $(du -h "$ISO_PATH" | cut -f1)"

# Delete existing VM if present
if virsh dominfo "$VM_NAME" &>/dev/null; then
  echo "Removing existing VM..."
  virsh destroy "$VM_NAME" &>/dev/null || true
  virsh undefine "$VM_NAME" --nvram &>/dev/null || true
fi

# Create disk if missing
if [ ! -f "$DISK_PATH" ]; then
  echo "Creating 50GB VM disk..."
  qemu-img create -f qcow2 "$DISK_PATH" 50G
fi

# Create VM
echo "Creating VM..."
virt-install \
  --name "$VM_NAME" \
  --ram "$RAM_MB" \
  --vcpus "$CPUS" \
  --disk path="$DISK_PATH",format=qcow2,bus=virtio \
  --cdrom "$ISO_PATH" \
  --os-variant ubuntu24.04 \
  --network network=default,model=virtio \
  --graphics spice,listen=127.0.0.1 \
  --noautoconsole \
  --boot cdrom,menu=on

echo ""
echo "=== VM Created ==="
echo "Name: $VM_NAME"
echo "Start: virsh start $VM_NAME"
echo "Console: virt-viewer $VM_NAME"
echo "List all: virsh list --all"
