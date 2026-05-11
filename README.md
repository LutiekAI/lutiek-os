# Lutiek OS 2026

A Windows 10-style operating system built on Ubuntu Linux 24.04 LTS.

## What It Does

- Extends life of unsupported Windows 10 PCs
- Preserves the Windows 10 user experience
- Hides Linux complexity from users
- Supports easy software installation
- Supports Windows application compatibility via Wine/Bottles
- Receives Ubuntu security/kernel updates
- Receives Lutiek UI/feature updates

## Tech Stack

- **Base:** Ubuntu 24.04 LTS
- **Desktop:** KDE Plasma
- **UI Apps:** Qt/QML
- **System Apps:** Rust + Tauri
- **Scripts:** Bash
- **Installer:** Calamares

## Phases

### Phase 1 — Base System
- Ubuntu 24.04 + KDE Plasma + SDDM
- Core packages (network, audio, flatpak, etc.)
- Installation: `sudo bash scripts/phase1-ubuntu-kde.sh`

### Phase 2 — Windows 10 Theme
- Windows 10 visual style (colors, fonts, icons, taskbar)
- SDDM login theme
- Lutiek branding
- Installation: `sudo bash scripts/phase2-theme-win10.sh`

### Phase 3 — Start Menu & App Center
- Custom Qt/QML start menu (Windows 10 layout)
- Lutiek App Center (APT + Flatpak GUI)
- Dolphin file manager customization
- Installation: `sudo bash scripts/phase3-startmenu.sh`

### Phase 4 — Compatibility & Tools
- Wine + Bottles integration
- Migration assistant
- Recovery system (Timeshift)
- Installation: `sudo bash scripts/phase4-compat.sh`

## Project Structure

```
lutiek-os/
├── branding/          — wallpapers, logos, icons
├── plasma-theme/      — KDE theme overrides
├── lutiek-launcher/   — Qt/QML start menu
├── lutiek-settings/   — Qt/QML settings app
├── lutiek-app-center/ — Tauri app store
├── compatibility-layer/ — Wine/Bottles integration
├── migration-tool/    — Windows migration assistant
├── updater/          — Lutiek update system
├── installer/        — Calamares customization
├── scripts/          — installation scripts
└── build-system/     — CI/CD, packaging
```

## Building a VM for Development

```bash
# 1. Create VM storage pool on external drive
virsh pool-define /tmp/lutiek-pool.xml
virsh pool-start lutiek-vm

# 2. Download Ubuntu ISO
wget -O vm-images/ubuntu-24.04-desktop.iso \
  https://releases.ubuntu.com/24.04/ubuntu-24.04.4-desktop-amd64.iso

# 3. Create VM (using virt-manager or virsh)
virt-install \
  --name lutiek-os-dev \
  --ram 4096 \
  --vcpus 2 \
  --disk path=/path/to/vm-image.qcow2,size=50 \
  --cdrom vm-images/ubuntu-24.04-desktop.iso \
  --os-variant ubuntu24.04 \
  --graphics spice

# 4. Run Phase 1 in the VM
bash scripts/phase1-ubuntu-kde.sh
```

## CI/CD

GitHub Actions build CI/CD for each component. See `.github/workflows/`.

## License

MIT License — see LICENSE
