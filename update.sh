#!/bin/bash
set -e

# =======================================
# Overleaf Extended CE - Update Script
# =======================================
# Updates to a new version of Extended CE.
# Usage: ./update.sh [version]
# Example: ./update.sh 6.2.0-ext-v3.6

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLKIT_DIR="${INSTALL_DIR:-$HOME/overleaf-toolkit}"

echo "============================================="
echo " Overleaf Extended CE - Update Script"
echo "============================================="

if [ ! -d "$TOOLKIT_DIR" ]; then
    echo "❌ Toolkit not found at $TOOLKIT_DIR"
    echo "   Run install.sh first."
    exit 1
fi

# Step 1: Get version info
CURRENT_VERSION=$(cat "$TOOLKIT_DIR/config/version" 2>/dev/null || echo "unknown")
echo "Current version: $CURRENT_VERSION"

if [ -n "$1" ]; then
    NEW_VERSION="$1"
else
    echo ""
    echo "Available Extended CE versions:"
    echo "  Check: https://hub.docker.com/r/overleafcep/sharelatex/tags"
    echo ""
    read -p "Enter new version (e.g. 6.2.0): " NEW_VERSION
fi

if [ -z "$NEW_VERSION" ]; then
    echo "❌ No version specified. Aborting."
    exit 1
fi

echo "Updating to version: $NEW_VERSION"

# Step 2: Update Overleaf Toolkit
echo "📦 Updating Overleaf Toolkit..."
cd "$TOOLKIT_DIR"
git pull origin master 2>/dev/null || echo "⚠️  Could not pull toolkit updates (may be on custom branch)"

# Step 3: Update version file
echo "$NEW_VERSION" > "$TOOLKIT_DIR/config/version"
echo "✅ Version file updated to $NEW_VERSION"

# Step 4: Update docker-compose.override.yml with new image tag
NEW_EXT_TAG="$NEW_VERSION"
echo "⚠️  Remember to update the image tag in config/docker-compose.override.yml"
echo "   Current image tag should match the new CEP release."
echo "   Check available tags at: https://hub.docker.com/r/overleafcep/sharelatex/tags"

# Step 5: Apply config from repo
echo "📋 Re-applying custom configuration..."
cp "$SCRIPT_DIR/config/overleaf.rc" "$TOOLKIT_DIR/config/overleaf.rc"
cp "$SCRIPT_DIR/config/docker-compose.override.yml" "$TOOLKIT_DIR/config/docker-compose.override.yml"
cp "$SCRIPT_DIR/config/90-git-bridge.sh" "$TOOLKIT_DIR/config/90-git-bridge.sh"
cp "$SCRIPT_DIR/config/git-bridge-settings.js" "$TOOLKIT_DIR/config/git-bridge-settings.js"
chmod +x "$TOOLKIT_DIR/config/90-git-bridge.sh"

# Step 6: Stop and recreate containers
echo ""
read -p "Stop and recreate containers now? (y/N): " CONFIRM
if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
    echo "🔄 Stopping services..."
    cd "$TOOLKIT_DIR" && bin/stop
    echo "🚀 Starting services with new version..."
    cd "$TOOLKIT_DIR" && bin/up -d
    echo ""
    echo "✅ Update complete! Waiting for services to start..."
    sleep 10
    cd "$TOOLKIT_DIR" && bin/docker-compose ps
else
    echo ""
    echo "To apply the update manually:"
    echo "  cd $TOOLKIT_DIR && bin/stop && bin/up -d"
fi

echo ""
echo "============================================="
echo " ✅ Update to $NEW_VERSION complete!"
echo "============================================="
