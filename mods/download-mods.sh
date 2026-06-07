#!/bin/bash
# Download SERVER-SIDE mods for Minecraft 26.1.2 NeoForge.
# Run this on the server (or locally) after cloning the repo:
#   bash mods/download-mods.sh
#
# Note: Distant Horizons / Iris / Sodium are CLIENT-SIDE only and are NOT
# downloaded here. They are not needed on the server.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODS_DIR="$SCRIPT_DIR"

download() {
  local out="$1" url="$2"
  if [[ -f "$MODS_DIR/$out" ]]; then
    echo "  exists, skipping: $out"
  else
    echo "  downloading: $out"
    curl -fL -o "$MODS_DIR/$out" "$url"
  fi
}

echo "Downloading server-side mods to $MODS_DIR..."

# WorldEdit 7.4.3 for NeoForge 26.1.2
download "worldedit-mod-7.4.3.jar" \
  "https://edge.forgecdn.net/files/8037/379/worldedit-mod-7.4.3.jar"

# Effortless Building 4.1 for NeoForge 26.1.2
download "effortlessbuilding-neoforge-26.1.2-4.1.jar" \
  "https://edge.forgecdn.net/files/8095/007/effortlessbuilding-neoforge-26.1.2-4.1.jar"

echo "Done. Mods present:"
ls -la "$MODS_DIR/"*.jar 2>/dev/null || echo "  (no jars found)"
