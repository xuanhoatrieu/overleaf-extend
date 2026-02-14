#!/bin/bash
set -e

# =======================================
# Overleaf Extended CE - Install Script
# =======================================
# This script installs the Overleaf Toolkit and applies
# your custom configuration from this repository.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLKIT_DIR="${INSTALL_DIR:-$HOME/overleaf-toolkit}"

echo "============================================="
echo " Overleaf Extended CE - Automated Installer"
echo "============================================="

# Step 1: Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   https://docs.docker.com/engine/install/"
    exit 1
fi
echo "✅ Docker found: $(docker --version)"

# Step 2: Clone Overleaf Toolkit (if needed)
if [ -d "$TOOLKIT_DIR" ]; then
    echo "⚠️  Toolkit directory exists: $TOOLKIT_DIR"
    echo "   Skipping clone. Use update.sh to update."
else
    echo "📦 Cloning Overleaf Toolkit..."
    git clone https://github.com/overleaf/toolkit.git "$TOOLKIT_DIR"
    echo "✅ Toolkit cloned to $TOOLKIT_DIR"
fi

# Step 3: Initialize config (if first time)
if [ ! -f "$TOOLKIT_DIR/config/overleaf.rc" ]; then
    echo "🔧 Initializing default config..."
    cd "$TOOLKIT_DIR" && bin/init
fi

# Step 4: Copy custom config
echo "📋 Applying custom configuration..."
cp "$SCRIPT_DIR/config/overleaf.rc" "$TOOLKIT_DIR/config/overleaf.rc"
cp "$SCRIPT_DIR/config/version" "$TOOLKIT_DIR/config/version"
cp "$SCRIPT_DIR/config/docker-compose.override.yml" "$TOOLKIT_DIR/config/docker-compose.override.yml"
cp "$SCRIPT_DIR/config/90-git-bridge.sh" "$TOOLKIT_DIR/config/90-git-bridge.sh"
cp "$SCRIPT_DIR/config/git-bridge-settings.js" "$TOOLKIT_DIR/config/git-bridge-settings.js"
chmod +x "$TOOLKIT_DIR/config/90-git-bridge.sh"

# Step 5: Handle variables.env
if [ -f "$TOOLKIT_DIR/config/variables.env" ]; then
    echo "⚠️  variables.env already exists — not overwriting (may contain secrets)."
    echo "   Compare with config/variables.env.template for any new settings."
else
    cp "$SCRIPT_DIR/config/variables.env.template" "$TOOLKIT_DIR/config/variables.env"
    echo "⚠️  Created variables.env from template — please edit with your actual values!"
fi

echo ""
echo "============================================="
echo " ✅ Configuration applied!"
echo "============================================="
echo ""
echo "Next steps:"
echo "  1. Edit $TOOLKIT_DIR/config/variables.env with your settings"
echo "  2. cd $TOOLKIT_DIR && bin/up -d"
echo "  3. Access at http://<server-ip>:8800"
echo ""
