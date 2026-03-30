#!/bin/bash
# Deploy QDM shell configs and create labwc-quickshell session
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QS_SRC="$SCRIPT_DIR"
QS_DEST="$HOME/.config/quickshell-qdm"
MATUGEN_DIR="$HOME/.config/matugen"
LABWC_DIR="$HOME/.config/labwc"
SESSION_FILE="/usr/share/wayland-sessions/labwc-quickshell.desktop"

# ── Quickshell config ─────────────────────────────────────────────
echo "==> Deploying CuteShell to $QS_DEST..."
if [ -d "$QS_DEST" ]; then
    echo "    Backing up existing to ${QS_DEST}.bak"
    rm -rf "${QS_DEST}.bak"
    mv "$QS_DEST" "${QS_DEST}.bak"
fi
cp -r "$QS_SRC" "$QS_DEST"
# Remove .git from deployed copy
rm -rf "$QS_DEST/.git"

# Ensure wallpaper state file exists
mkdir -p "$QS_DEST/colors"
touch "$QS_DEST/.wallpaper"

# ── Matugen config ────────────────────────────────────────────────
echo "==> Setting up matugen config..."
mkdir -p "$MATUGEN_DIR/templates"

cat > "$MATUGEN_DIR/config.toml" << 'TOML'
[config]

[templates.quickshell]
input_path  = "~/.config/matugen/templates/quickshell.tera"
output_path = "~/.config/quickshell-qdm/colors/matugen.json"
TOML

# Only write template if it doesn't exist (user may have customized)
if [ ! -f "$MATUGEN_DIR/templates/quickshell.tera" ]; then
cat > "$MATUGEN_DIR/templates/quickshell.tera" << 'TERA'
{
  "primary": "{{colors.primary.default.hex}}",
  "on_primary": "{{colors.on_primary.default.hex}}",
  "primary_container": "{{colors.primary_container.default.hex}}",
  "on_primary_container": "{{colors.on_primary_container.default.hex}}",
  "secondary": "{{colors.secondary.default.hex}}",
  "on_secondary": "{{colors.on_secondary.default.hex}}",
  "secondary_container": "{{colors.secondary_container.default.hex}}",
  "tertiary": "{{colors.tertiary.default.hex}}",
  "on_tertiary": "{{colors.on_tertiary.default.hex}}",
  "tertiary_container": "{{colors.tertiary_container.default.hex}}",
  "surface": "{{colors.surface.default.hex}}",
  "on_surface": "{{colors.on_surface.default.hex}}",
  "surface_variant": "{{colors.surface_variant.default.hex}}",
  "on_surface_variant": "{{colors.on_surface_variant.default.hex}}",
  "background": "{{colors.background.default.hex}}",
  "on_background": "{{colors.on_background.default.hex}}",
  "error": "{{colors.error.default.hex}}",
  "outline": "{{colors.outline.default.hex}}",
  "outline_variant": "{{colors.outline_variant.default.hex}}"
}
TERA
fi

# ── labwc autostart ───────────────────────────────────────────────
echo "==> Configuring labwc autostart..."
mkdir -p "$LABWC_DIR"

AUTOSTART="$LABWC_DIR/autostart"
# Create or update autostart — preserve user entries
if [ -f "$AUTOSTART" ]; then
    # Remove old QDM entries if re-deploying
    grep -v '# QDM' "$AUTOSTART" | grep -v 'awww-daemon' | grep -v 'quickshell.*quickshell-qdm' > "${AUTOSTART}.tmp" || true
    mv "${AUTOSTART}.tmp" "$AUTOSTART"
fi

cat >> "$AUTOSTART" << 'SH'
# QDM - awww wallpaper daemon
awww-daemon &
# QDM - quickshell bar
quickshell -p ~/.config/quickshell-qdm/ &
SH
chmod +x "$AUTOSTART"

# ── Session .desktop file ────────────────────────────────────────
echo "==> Creating labwc-quickshell session (requires sudo)..."
sudo tee "$SESSION_FILE" > /dev/null << 'DESKTOP'
[Desktop Entry]
Name=labwc (QDM Shell)
Comment=labwc with Quickshell QDM desktop
Exec=labwc
Icon=labwc
Type=Application
DesktopNames=labwc;wlroots
DESKTOP

echo ""
echo "==> Deployed! You can now:"
echo "    - Select 'labwc (QDM Shell)' from your login screen"
echo "    - Or run: labwc  (autostart handles the rest)"
echo ""
echo "    Shell config:  $QS_DEST/"
echo "    labwc autostart: $AUTOSTART"
