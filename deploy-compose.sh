#!/usr/bin/env bash
#
# 5DV — Docker Compose deploy script
# Deploys using docker-compose.yaml (recommended for most users).
#
# Usage:  ./deploy-compose.sh [PORT]
#   PORT   optional host port (default: 8282)
#
set -euo pipefail

PORT="${1:-8282}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yaml"

echo "╔══════════════════════════════════════════╗"
echo "║     5DV — Compose Deploy Script          ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Check if docker compose is available
if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
else
  echo "✗ Docker Compose is not installed."
  echo "  Install it: https://docs.docker.com/compose/install/"
  exit 1
fi

# Create data directories
mkdir -p "$SCRIPT_DIR/db" "$SCRIPT_DIR/logos"
echo "✓ Data directories ready (db/, logos/)"

# Patch the port if a custom one is given
if [ "$PORT" != "8282" ]; then
  echo "ℹ Using custom port: $PORT"
  sed -i.bak "s/8282:80/$PORT:80/" "$COMPOSE_FILE"
  echo "  (docker-compose.yaml backed up to docker-compose.yaml.bak)"
fi

echo "↓ Pulling latest image..."
$COMPOSE_CMD -f "$COMPOSE_FILE" pull

echo "▶ Starting 5DV..."
$COMPOSE_CMD -f "$COMPOSE_FILE" up -d

echo ""
echo "✓ 5DV is running at http://localhost:$PORT"
echo "  First visit will show the registration page to create your admin account."
echo ""
echo "  Useful commands:"
echo "    docker compose -f docker-compose.yaml logs -f   # view logs"
echo "    docker compose -f docker-compose.yaml down       # stop"
echo "    docker compose -f docker-compose.yaml pull && \\
     docker compose -f docker-compose.yaml up -d        # update"
