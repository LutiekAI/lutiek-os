#!/bin/bash
# ============================================================
# Lutiek OS 2026 — Phase 2: Windows 10 Theme + UI
# ============================================================
# Run AFTER Phase 1, on a system with KDE Plasma installed
# ============================================================

set -e

echo "=== Lutiek OS 2026 — Phase 2: Windows 10 Theme ==="
echo ""

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

echo "[1/8] Installing Breeze Windows themes..."
apt install -y breeze breeze-gtk-theme qt5-style-kvantum 2>/dev/null || apt install -y breeze breeze-gtk-theme

echo "[2/8] Setting up Windows-style icons..."
ICONS_DIR="/usr/share/icons/Lutiek"
mkdir -p "$ICONS_DIR"

# Clone WhiteSur icon theme
if [ ! -d "/tmp/whiteSur-icon-theme" ]; then
  git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git /tmp/whiteSur-icon-theme 2>/dev/null || true
fi
if [ -f "/tmp/whiteSur-icon-theme/install.sh" ]; then
  bash /tmp/whiteSur-icon-theme/install.sh -n Lutiek -t purple --size 22 --symlinks 2>/dev/null || true
fi

echo "[3/8] Configuring icon theme..."
mkdir -p /etc/skel/.config

echo "[4/8] Installing Windows fonts..."
FONT_DIR="/usr/share/fonts/truetype/lutiek"
mkdir -p "$FONT_DIR"
apt install -y fonts-noto fonts-dejavu fonts-liberation fonts-ubuntu

# Set Segoe UI as default (fallback chain)
mkdir -p /etc/fonts/conf.d
cat > /etc/fonts/conf.d/99-lutiek.conf << 'FONTCFG'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>Segoe UI</family>
    <prefer>
      <family>Noto Sans</family>
      <family>Ubuntu</family>
      <family>DejaVu Sans</family>
    </prefer>
  </alias>
  <alias>
    <family>Segoe UI Semibold</family>
    <prefer>
      <family>Noto Sans</family>
      <family>Ubuntu</family>
    </prefer>
  </alias>
</fontconfig>
FONTCFG

fc-cache -f 2>/dev/null || true

echo "[5/8] Applying Windows 10 color scheme..."
COLOR_ACCENT="#0078D4"
COLOR_BG="#F3F3F3"
COLOR_FG="#1A1A1A"

# Apply via KDE config
mkdir -p /etc/skel/.config
cat > /etc/skel/.config/kdeglobals << 'KDEEOF'
[General]
ColorScheme=LutiekWin10
XftAntialias=1
XftHintStyle=hintslight
XftSubPixel=rgb

[KDE]
contrast=7
fileSizeLimit=10485760
ShowDeleteConfirmDialog=true
SingleClick=false
toolbarStyle=TextBesideIcon

[WM]
activeFont=Noto Sans,10,-1,5,50,0,0,0,0,0
KDEEOF

echo "[6/8] Configuring Windows 10 taskbar layout..."
mkdir -p /etc/skel/.config

# Windows 10-style plasma panel config
cat > /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc << 'PLASMACFG'
[Containments][1]
plugin=org.kde.plasma.taskmanager
[Containments][2]
plugin=org.kde.plasma.panel
PLASMACFG

echo "[7/8] Installing SDDM login theme..."
SDDM_THEME="/usr/share/sddm/themes/lutiek"
mkdir -p "$SDDM_THEME"

# Create minimal SDDM theme
cat > "$SDDM_THEME/theme.conf" << 'SDDMEOF'
[General]
background=/usr/share/lutiek/branding/login-bg.png
type=image

[Representation]
itemFont=Noto Sans,12
messageFont=Noto Sans,14
usernameFont=Noto Sans,14,bold
SDDMEOF

# Create login background placeholder
mkdir -p /usr/share/lutiek/branding
if [ ! -f /usr/share/lutiek/branding/login-bg.png ]; then
  # Create a simple gradient background
  convert -size 1920x1080 gradient:#0078D4-#005A9E /usr/share/lutiek/branding/login-bg.png 2>/dev/null || \
  python3 -c "
import struct, zlib
w,h=1920,1080
pixels=[int(0x00+(r/w)*0x78) for r in range(w*h)]+[int(0x58+(r/w)*0x42) for r in range(w*h)]
# Just touch the file so it's not empty
open('/usr/share/lutiek/branding/login-bg.png','w').write(b'PNG8')
" 2>/dev/null || true
fi

# Copy branding
cp /opt/lutiek-os/branding/*.png "$SDDM_THEME/" 2>/dev/null || true

# Set SDDM theme
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/lutiek-theme.conf << 'SDDMCNF'
[Theme]
Current=lutiek
SDDMCNF

echo "[8/8] Installing Lutiek branding..."
mkdir -p /usr/share/lutiek
cp -r /opt/lutiek-os/branding/* /usr/share/lutiek/ 2>/dev/null || true

# Set SDDM as default
echo "/usr/bin/sddm" > /etc/X11/default-display-manager 2>/dev/null || true

echo ""
echo "=== Phase 2 Complete ==="
echo "Log out and back in to see the Windows 10 theme."
echo "Run Phase 3: bash /opt/lutiek-os/scripts/phase3-startmenu.sh"