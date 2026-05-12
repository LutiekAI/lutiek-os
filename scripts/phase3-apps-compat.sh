#!/bin/bash
# ============================================================
# Lutiek OS 2026 — Phase 3: App Center + Compatibility
# ============================================================
set -e

echo "=== Lutiek OS 2026 — Phase 3: App Center + Compatibility ==="
echo ""

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

echo "[1/5] Installing App Center dependencies..."
apt install -y plasma-discover plasma-discover-backend-flatpak plasma-discover-backend-snap

echo "[2/5] Installing Windows compatibility layer..."
apt install -y wine wine32 wine64 winetricks bottles 2>/dev/null || true

echo "[3/5] Configuring Bottles..."
mkdir -p ~/.config/bottles
mkdir -p ~/Bottles

echo "[4/5] Setting up Flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

echo "[5/5] Creating file associations..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/lutiek-compatibility.desktop << 'EOF'
[Desktop Entry]
Name=Lutiek Compatibility
Comment=Run Windows applications
Exec=bottles
Icon=wine
Terminal=false
Type=Application
Categories=System;Utility;
EOF

echo ""
echo "=== Phase 3 Complete ==="
echo "Run Phase 4: bash /opt/lutiek-os/scripts/phase4-polish.sh"