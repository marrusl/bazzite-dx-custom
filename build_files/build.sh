#!/bin/bash

set -ouex pipefail

### Add third-party repositories

# Claude Desktop (aaddrick community build)
# https://github.com/aaddrick/claude-desktop-debian
curl -fsSL https://aaddrick.github.io/claude-desktop-debian/rpm/claude-desktop.repo \
    -o /etc/yum.repos.d/claude-desktop.repo

# Ghostty terminal - COPR
dnf5 -y copr enable scottames/ghostty

# lact (GPU control) - COPR
dnf5 -y copr enable ilyaz/LACT

# Google Cloud CLI
curl -fsSL https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg \
    -o /etc/pki/rpm-gpg/google-cloud-sdk.gpg
cat > /etc/yum.repos.d/google-cloud-sdk.repo << 'EOF'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/google-cloud-sdk.gpg
EOF

### Install packages

# Packages from Fedora repos
dnf5 install -y \
    bat \
    gh \
    iotop \
    krb5-workstation \
    neovim \
    nicotine+ \
    python3-pyclip \
    variety

# Packages from third-party repos
dnf5 install -y \
    claude-desktop \
    ghostty \
    google-cloud-cli \
    lact

# Disable COPRs so they don't end up enabled on the final image
dnf5 -y copr disable scottames/ghostty
dnf5 -y copr disable ilyaz/LACT

# Clean up build-time-only repos
rm -f /etc/yum.repos.d/claude-desktop.repo
rm -f /etc/yum.repos.d/google-cloud-sdk.repo
rm -f /etc/pki/rpm-gpg/google-cloud-sdk.gpg

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

### Enable services

systemctl enable podman.socket
systemctl enable lactd.service
systemctl enable bazzite-dx-custom-flatpak-install.service
