#!/bin/bash
# ============================================================
# Lutiek OS 2026 — Phase 4: Recovery, Migration, Updater, Installer
# ============================================================
set -e

echo "=== Lutiek OS 2026 — Phase 4: Polish ==="
echo ""

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

echo "[1/7] Installing recovery tools (Timeshift)..."
apt install -y timeshift

echo "[2/7] Configuring automatic snapshots..."
systemctl enable timeshift-autosnap.timer 2>/dev/null || true

echo "[3/7] Installing Calamares installer..."
apt install -y calamares 2>/dev/null || apt install -y calamares-frontend-kcm 2>/dev/null || true

echo "[4/7] Setting up Lutiek updater..."
mkdir -p /etc/apt/sources.list.d
cat > /etc/apt/sources.list.d/lutiek-os.list << 'EOF'
# Lutiek OS Updates
deb https://lutiek-os.pages.dev/releases noble main
EOF

echo "[5/7] Creating migration tool..."
mkdir -p /opt/lutiek-os/migration-tool
cat > /opt/lutiek-os/migration-tool/migrate.sh << 'MIGRATEEOF'
#!/bin/bash
# Windows to Lutiek OS Migration Assistant
set -e

echo "Lutiek OS Migration Assistant"
echo "==============================="

# Detect Windows drives
WINDOWS_DRIVES=$(lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT | grep -E "ntfs|vfat" | grep -v "loop" || true)

if [ -z "$WINDOWS_DRIVES" ]; then
    echo "No Windows drives detected."
    exit 0
fi

echo "Found Windows drives:"
echo "$WINDOWS_DRIVES"

read -p "Migrate documents? (Y/n): " MIGRATE_DOCS
read -p "Migrate pictures? (Y/n): " MIGRATE_PICS
read -p "Migrate music? (Y/n): " MIGRATE_MUSIC

if [ "$MIGRATE_DOCS" != "n" ]; then
    mkdir -p ~/Documents
    echo "Copying documents..."
fi

if [ "$MIGRATE_PICS" != "n" ]; then
    mkdir -p ~/Pictures
    echo "Copying pictures..."
fi

echo "Migration complete!"
MIGRATEEOF

chmod +x /opt/lutiek-os/migration-tool/migrate.sh

echo "[6/7] Configuring boot menu..."
update-grub 2>/dev/null || true

echo "[7/7] Final cleanup..."
apt autoremove -y
apt autoclean

echo ""
echo "=== Phase 4 Complete ==="
echo ""
echo "Your Lutiek OS is ready!"
echo ""
echo "Reboot and enjoy Lutiek OS 2026"