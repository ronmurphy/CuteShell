#!/bin/bash
# Install dependencies for QDM (Quickshell Desktop on labwc)
# Requires: yay or paru (AUR helper)

set -e

AUR=""
if command -v paru &>/dev/null; then
    AUR="paru"
elif command -v yay &>/dev/null; then
    AUR="yay"
else
    echo "Error: paru or yay required"
    exit 1
fi

echo "==> Installing dependencies via $AUR..."

# Core
$AUR -S --needed \
    labwc \
    quickshell \
    awww \
    matugen-bin \
    qt6-base \
    qt6-declarative \
    qt6-wayland

# Optional (fonts, cursors, etc)
$AUR -S --needed \
    ttf-nerd-fonts-symbols \
    capitaine-cursors

echo "==> Done. Run ./deploy.sh next."
