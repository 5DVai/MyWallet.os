#!/usr/bin/env bash
#
# 5DV — Backup script
# Creates a timestamped tar.gz of your database and uploaded logos.
#
# Usage:  ./backup.sh [OUTPUT_DIR]
#   OUTPUT_DIR   optional backup destination (default: ./backups)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${1:-$SCRIPT_DIR/backups}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_FILE="$OUTPUT_DIR/5dv-backup-$TIMESTAMP.tar.gz"

echo "╔══════════════════════════════════════════╗"
echo "║          5DV — Backup Script             ║"
echo "╚══════════════════════════════════════════╝"
echo ""

mkdir -p "$OUTPUT_DIR"

# Stop the container briefly for a consistent DB snapshot
WAS_RUNNING=false
if docker ps --format '{{.Names}}' | grep -q '^wallos$'; then
  echo "■ Pausing container for consistent snapshot..."
  docker stop wallos >/dev/null
  WAS_RUNNING=true
fi

echo "📦 Creating backup: $BACKUP_FILE"
tar -czf "$BACKUP_FILE" \
  -C "$SCRIPT_DIR" \
  db/ logos/ 2>/dev/null || true

if [ "$WAS_RUNNING" = true ]; then
  echo "▶ Resuming container..."
  docker start wallos >/dev/null
fi

BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo ""
echo "✓ Backup complete: $BACKUP_FILE ($BACKUP_SIZE)"
echo "  To restore: ./restore.sh $BACKUP_FILE"
