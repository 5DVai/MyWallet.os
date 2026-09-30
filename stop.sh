#!/usr/bin/env bash
#
# 5DV — Stop / Start / Logs helper
# Quick commands to manage the running 5DV container.
#
# Usage:
#   ./stop.sh          — stop the container
#   ./stop.sh start    — start the container
#   ./stop.sh restart  — restart the container
#   ./stop.sh logs     — tail container logs
#   ./stop.sh status   — show container status
#
set -euo pipefail

ACTION="${1:-stop}"

case "$ACTION" in
  stop)
    echo "■ Stopping 5DV..."
    docker stop wallos 2>/dev/null && echo "✓ Stopped." || echo "ℹ Container not running."
    ;;
  start)
    echo "▶ Starting 5DV..."
    docker start wallos 2>/dev/null && echo "✓ Started." || echo "✗ Container not found. Use ./deploy.sh first."
    ;;
  restart)
    echo "↻ Restarting 5DV..."
    docker restart wallos 2>/dev/null && echo "✓ Restarted." || echo "✗ Container not found. Use ./deploy.sh first."
    ;;
  logs)
    echo "📋 5DV logs (Ctrl+C to exit):"
    echo ""
    docker logs -f --tail 100 wallos 2>/dev/null || echo "✗ Container not found."
    ;;
  status)
    echo "ℹ 5DV container status:"
    docker ps -a --filter name=wallos --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "✗ Container not found."
    ;;
  *)
    echo "Usage: ./stop.sh [stop|start|restart|logs|status]"
    exit 1
    ;;
esac
