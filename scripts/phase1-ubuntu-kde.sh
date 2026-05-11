#!/bin/bash
# ============================================================
# Lutiek OS 2026 — Phase 1: Ubuntu 24.04 + KDE Plasma Install
# ============================================================
# Run on a FRESH Ubuntu 24.04 LTS system
# WARNING: This installs and configures a full desktop environment.
#          Do NOT run on a production system without understanding.
# ============================================================

set -e

echo "=== Lutiek OS 2026 — Phase 1 Installer ==="
echo ""

# Check running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Detect if KDE is already running
if pgrep -x plasmashell > /dev/null; then
  echo "KDE Plasma detected. Skipping KDE installation."
  SKIP_KDE=1
else
  SKIP_KDE=0
fi

echo "Phase 1: Installing Ubuntu base + KDE Plasma Desktop"
echo ""

# ------------------------------------------------------------
# Step 1: System update
# ------------------------------------------------------------
echo "[1/6] Updating system..."
export DEBIAN_FRONTEND=noninteractive
apt update
apt upgrade -y

# ------------------------------------------------------------
# Step 2: Install KDE Plasma Desktop
# ------------------------------------------------------------
if [ "$SKIP_KDE" -eq 0 ]; then
  echo "[2/6] Installing KDE Plasma Desktop..."
  apt install -y kde-plasma-desktop
  echo "[2/6] Installing additional KDE components..."
  apt install -y plasma-nm plasma-workspace dolphin konsole kate systemsettings
fi

# ------------------------------------------------------------
# Step 3: Install SDDM display manager
# ------------------------------------------------------------
echo "[3/6] Installing SDDM..."
apt install -y sddm
# Set SDDM as default display manager
echo "/usr/bin/sddm" > /etc/X11/default-display-manager
systemctl set-default graphical.target

# ------------------------------------------------------------
# Step 4: Install required packages
# ------------------------------------------------------------
echo "[4/6] Installing Lutiek OS core packages..."
apt install -y \
  network-manager \
  pipewire \
  pipewire-audio-client-libraries \
  flatpak \
  discover \
  curl \
  wget \
  git \
  build-essential \
  zram-tools \
  earlyoom \
  firewalld \
  apparmor \
  qml-module-qtquick-controls \
  qml-module-qtquick-layouts \
  qml-module-qt-labs-settings \
  qtbase5-dev \
  qtdeclarative5-dev \
  kirigami2-dev \
  libkf5config-dev \
  libkf5coreaddons-dev \
  libkf5i18n-dev \
  rustc \
  cargo \
  libssl-dev \
  pkg-config

# ------------------------------------------------------------
# Step 5: Enable services
# ------------------------------------------------------------
echo "[5/6] Enabling services..."
systemctl enable NetworkManager
systemctl enable firewalld
systemctl enable earlyoom

# ------------------------------------------------------------
# Step 6: Clone Lutiek OS repo (if not present)
# ------------------------------------------------------------
echo "[6/6] Setting up Lutiek OS source..."
if [ ! -d "/opt/lutiek-os" ]; then
  git clone https://github.com/LutiekAI/lutiek-os.git /opt/lutiek-os
fi

echo ""
echo "=== Phase 1 Complete ==="
echo "Please REBOOT now: sudo reboot"
echo "After reboot, run Phase 2: bash /opt/lutiek-os/scripts/phase2-theme-winxp.sh"
