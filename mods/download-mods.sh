#!/bin/bash
# Download server-side mods for Minecraft 26.1.2 NeoForge
# Run this on your server after cloning the repo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODS_DIR="$SCRIPT_DIR"

echo "Downloading server-side mods to $MODS_DIR..."

# WorldEdit 7.4.3 for NeoForge 26.1.2
curl -L -o "$MODS_DIR/worldedit-mod-7.4.3.jar" "https://edge.forgecdn.net/files/8037/379/worldedit-mod-7.4.3.jar"

# Effortless Building 4.1 for NeoForge 26.1.2
curl -L -o "$MODS_DIR/effortlessbuilding-neoforge-26.1.2-4.1.jar" "https://edge.forgecdn.net/files/8095/007/effortlessbuilding-neoforge-26.1.2-4.1.jar"

echo "Done! Downloaded mods:"
ls -la "$MODS_DIR/"
