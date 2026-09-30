#!/usr/bin/env bash
#
# 5DV — Update script
# Pulls the latest image and restarts the container with zero data loss.
#
# Usage:  ./update.sh
#
set -euo pipefail

IMAGE="bellamy/wallos:latest"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔══════════════════════════════════════════╗"
echo "║          5DV — Update Script             ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q '^wallos$'; then
  echo "✗ 5DV container is not running. Use ./deploy.sh first."
  exit 1
fi

# Get current port
CURRENT_PORT=$(docker port wallos 80 2>/dev/null | head -1 | sed 's/.*://')
CURRENT_PORT="${CURRENT_PORT:-8282}"
CURRENT_TZ=$(docker inspect wallos --format '{{range .Config.Env}}{{println .}}{{end}}' | grep '^TZ=' | cut -d= -f2 || echo 'America/Toronto')

echo "↓ Pulling latest image..."
docker pull "$IMAGE"

echo "■ Stopping old container..."
docker stop wallos
docker rm wallos

echo "▶ Starting updated 5DV..."
docker run -d \
  --name wallos \
  -v "$SCRIPT_DIR/db:/var/www/html/db" \
  -v "$SCRIPT_DIR/logos:/var/www/html/images/uploads/logos" \
  -e TZ="$CURRENT_TZ" \
  -p "$CURRENT_PORT:80" \
  --restart unless-stopped \
  "$IMAGE"

echo ""
echo "✓ 5DV updated and running at http://localhost:$CURRENT_PORT"
echo "  Your data in db/ and logos/ is preserved."
