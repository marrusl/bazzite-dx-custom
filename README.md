# bazzite-dx-custom

Custom [Bazzite DX](https://github.com/ublue-os/bazzite-dx) GNOME image with personal tweaks, built on the [ublue-os/image-template](https://github.com/ublue-os/image-template).

## What's included

**Base image:** `ghcr.io/ublue-os/bazzite-dx-gnome:stable` — which provides:

- Bazzite gaming stack (Steam, Gamescope, MangoHud, custom kernel, etc.)
- Bazzite DX developer tools (Docker, VS Code with devcontainers, Homebrew, container-centric terminal)
- GNOME desktop environment
- Open source GPU drivers (AMD/Intel)

**Custom additions:** see `build_files/build.sh` for any packages or services added on top.

## Installation

### Switch from an existing Bazzite GNOME installation

```bash
sudo bootc switch ghcr.io/marrusl/bazzite-dx-custom:latest
sudo systemctl reboot
```

### Switch from any bootc system

```bash
sudo bootc switch ghcr.io/marrusl/bazzite-dx-custom:latest
sudo systemctl reboot
```

## Setup

### Image Signing (required for builds to succeed)

1. Install [cosign](https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/)
2. Generate a key pair: `COSIGN_PASSWORD="" cosign generate-key-pair`
3. Add the contents of `cosign.key` as a GitHub Actions secret named `SIGNING_SECRET`
4. Replace `cosign.pub` in this repo with your public key
5. Never commit `cosign.key` to the repo

### Customization

Add packages in `build_files/build.sh`:

```bash
dnf5 install -y package-name
```

## Local Testing

```bash
just build              # Build container image
just build-qcow2        # Build VM disk image
just run-vm-qcow2       # Test in browser-based VM
```

## Links

- [Bazzite](https://bazzite.gg/)
- [Bazzite DX](https://dev.bazzite.gg/)
- [Universal Blue](https://universal-blue.org/)
- [bootc Documentation](https://containers.github.io/bootc/)
