#!/bin/bash

set -ouex pipefail

### Add third-party repositories

# Claude Desktop (aaddrick community build)
# https://github.com/aaddrick/claude-desktop-debian
curl -fsSL https://aaddrick.github.io/claude-desktop-debian/rpm/claude-desktop.repo \
    -o /etc/yum.repos.d/claude-desktop.repo

# lact (GPU control) - COPR
dnf5 -y copr enable ilya-fedin/lact

### Install packages

# Packages from Fedora repos
dnf5 install -y \
    bat \
    gh \
    ghostty \
    iotop \
    krb5-workstation \
    neovim \
    nicotine+ \
    python3-pyclip \
    variety \
    wine-devel

# Packages from third-party repos
dnf5 install -y \
    claude-desktop \
    lact

# Disable COPRs so they don't end up enabled on the final image
dnf5 -y copr disable ilya-fedin/lact

# Clean up claude-desktop repo (installed at build time only)
rm -f /etc/yum.repos.d/claude-desktop.repo

### Flatpak first-boot installer
# Flatpaks can't be installed during container build (no D-Bus, no network).
# Instead, install a list + systemd service that runs on first boot.

# Install the flatpak list
install -Dm644 /ctx/flatpaks/install \
    /usr/share/bazzite-dx-custom/flatpak/install

# Install the first-boot script
install -Dm755 /ctx/scripts/bazzite-dx-custom-flatpak-install \
    /usr/libexec/bazzite-dx-custom-flatpak-install

# Install the systemd service
install -Dm644 /ctx/scripts/bazzite-dx-custom-flatpak-install.service \
    /usr/lib/systemd/system/bazzite-dx-custom-flatpak-install.service

### Stream Deck udev rules
# Required for OpenDeck/StreamController to detect Elgato devices
cat > /etc/udev/rules.d/60-streamdeck.rules << 'EOF'
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", TAG+="uaccess"
EOF

### Enable services

systemctl enable podman.socket
systemctl enable lactd.service
systemctl enable bazzite-dx-custom-flatpak-install.service
