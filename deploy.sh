#!/usr/bin/env bash
#
# 5DV — One-command deploy script
# Pulls the latest image, creates data directories, and starts the app.
#
# Usage:  ./deploy.sh [PORT]
#   PORT   optional host port (default: 8282)
#
set -euo pipefail

PORT="${1:-8282}"
IMAGE="bellamy/wallos:latest"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔══════════════════════════════════════════╗"
echo "║          5DV — Deploy Script              ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Port:   $PORT"
echo "Image: $IMAGE"
echo "Folder: $SCRIPT_DIR"
echo ""

# Create data directories if they don't exist
mkdir -p "$SCRIPT_DIR/db" "$SCRIPT_DIR/logos"
echo "✓ Data directories ready (db/, logos/)"

# Pull the latest image
echo "↓ Pulling latest image..."
docker pull "$IMAGE"

# Start the container
echo "▶ Starting 5DV..."
docker run -d \
  --name wallos \
  -v "$SCRIPT_DIR/db:/var/www/html/db" \
  -v "$SCRIPT_DIR/logos:/var/www/html/images/uploads/logos" \
  -e TZ="$(cat /etc/timezone 2>/dev/null || echo 'America/Toronto')" \
  -p "$PORT:80" \
  --restart unless-stopped \
  "$IMAGE"

echo ""
echo "✓ 5DV is running at http://localhost:$PORT"
echo "  First visit will show the registration page to create your admin account."
