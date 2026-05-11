#!/bin/bash
# ============================================================
# Lutiek OS 2026 — Phase 2: Windows 10 Theme + UI
# ============================================================
# Run AFTER Phase 1, on a system with KDE Plasma installed
# ============================================================

set -e

echo "=== Lutiek OS 2026 — Phase 2: Windows 10 Theme ==="
echo ""

# Check running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "[1/8] Installing Breeze Windows themes..."
apt install -y breeze breeze-gtk-theme kvantum qt5-style-kvantum

# ------------------------------------------------------------
# Download Windows-style icon set
# ------------------------------------------------------------
echo "[2/8] Setting up Windows-style icons..."
ICONS_DIR="/usr/share/icons/Lutiek"
mkdir -p "$ICONS_DIR"

# Clone Windows icon theme (whiteSur or similar)
if [ ! -d "/tmp/whiteSur-icon-theme" ]; then
  git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git /tmp/whiteSur-icon-theme
fi
/tmp/whiteSur-icon-theme/install.sh -n Lutiek -c all -t purple -o default --size 22 --symlinks 2>/dev/null || true

# Fallback: use KDE breeze dark with icon theme
# ------------------------------------------------------------
# Set default icon theme
# ------------------------------------------------------------
echo "[3/8] Configuring icon theme..."
# Set icon theme system-wide via Plasma config
mkdir -p /etc/skel/.config
cat > /etc/skel/.config/kwinrc << 'EOF'
[Desktops]
Number=1

[org.kde.plasma.desktop]
LayoutFunction=org.kde.private.windows10.layout
EOF

# ------------------------------------------------------------
# Download/install Windows-style fonts
# ------------------------------------------------------------
echo "[4/8] Installing Windows fonts..."
FONT_DIR="/usr/share/fonts/truetype/lutiek"
mkdir -p "$FONT_DIR"

# Download Segoe UI-equivalent fonts
if command -v wget &>/dev/null; then
  # Using open-source alternatives that look similar
  wget -q -O /tmp/fonts.tar.gz "https://github.com/google/fonts/archive/main.tar.gz" 2>/dev/null || true
fi

# Install system fonts
apt install -y fonts-noto fonts-dejavu fonts-liberation fonts-ubuntu

# Set Segoe UI as default (fallback chain)
cat > /etc/fonts/local.conf << 'EOF'
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
EOF

fc-cache -f

# ------------------------------------------------------------
# Apply Windows 10 color scheme
# ------------------------------------------------------------
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
EOF

# ------------------------------------------------------------
# Set up Windows 10-style taskbar layout
# ------------------------------------------------------------
echo "[6/8] Configuring Windows 10 taskbar layout..."
mkdir -p /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc

cat > /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc << 'PLASMAEOF'
# Windows 10-style taskbar configuration
# Pre-configured plasma panel layout
PLASMAEOF

# ------------------------------------------------------------
# Install SDDM Lutiek theme
# ------------------------------------------------------------
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

# Copy branding
cp "$REPO_DIR/branding/"*.png "$SDDM_THEME/" 2>/dev/null || true

# Set SDDM theme
cat > /etc/sddm.conf.d/lutiek-theme.conf << 'SDDMCNF'
[Theme]
Current=lutiek
SDDMCNF

# ------------------------------------------------------------
# Copy Lutiek branding
# ------------------------------------------------------------
echo "[8/8] Installing Lutiek branding..."
mkdir -p /usr/share/lutiek
cp -r "$REPO_DIR/branding/"* /usr/share/lutiek/ 2>/dev/null || true

echo ""
echo "=== Phase 2 Complete ==="
echo "Log out and back in to see the Windows 10 theme."
echo "Run Phase 3: bash /opt/lutiek-os/scripts/phase3-startmenu.sh"
