# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image: Bazzite DX GNOME (developer experience + gaming + GNOME desktop)
FROM ghcr.io/ublue-os/bazzite-dx-gnome:stable

## Other possible base images:
# FROM ghcr.io/ublue-os/bazzite-dx:stable              # KDE variant
# FROM ghcr.io/ublue-os/bazzite-dx-nvidia-gnome:stable  # GNOME + NVIDIA
# FROM ghcr.io/ublue-os/bazzite-gnome:stable            # GNOME without DX tools

### MODIFICATIONS
## Make modifications desired in your image and install packages by modifying build.sh.
## The following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
