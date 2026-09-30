#!/usr/bin/env bash
#
# 5DV — Restore script
# Restores database and logos from a backup archive.
#
# Usage:  ./restore.sh <BACKUP_FILE>
#   BACKUP_FILE   path to a 5dv-backup-*.tar.gz archive
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -lt 1 ]; then
  echo "Usage: ./restore.sh <BACKUP_FILE>"
  echo "  Example: ./restore.sh ./backups/5dv-backup-20260101-120000.tar.gz"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "✗ Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "╔══════════════════════════════════════════╗"
echo "║          5DV — Restore Script            ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Archive: $BACKUP_FILE"
echo ""

# Stop the container if running
WAS_RUNNING=false
if docker ps --format '{{.Names}}' | grep -q '^wallos$'; then
  echo "■ Stopping container..."
  docker stop wallos >/dev/null
  WAS_RUNNING=true
fi

echo "📂 Extracting backup..."
tar -xzf "$BACKUP_FILE" -C "$SCRIPT_DIR"

if [ "$WAS_RUNNING" = true ]; then
  echo "▶ Restarting container..."
  docker start wallos >/dev/null
fi

echo ""
echo "✓ Restore complete. Your data has been restored from: $BACKUP_FILE"
