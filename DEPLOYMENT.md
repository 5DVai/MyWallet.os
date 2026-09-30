# 5DV — Deployment Scripts

Quick-start helper scripts for deploying and managing your 5DV instance.

## Quick Start

```bash
# One-command deploy (Docker)
./deploy.sh

# Or deploy with Docker Compose (recommended)
./deploy-compose.sh

# Custom port
./deploy.sh 9000
```

Then open `http://localhost:8282` (or your custom port) to create your admin account.

## Scripts

| Script | Description |
|---|---|
| `deploy.sh` | First-time deploy via `docker run`. Creates data dirs, pulls image, starts container. |
| `deploy-compose.sh` | First-time deploy via `docker-compose.yaml`. Recommended for most users. |
| `update.sh` | Pull the latest image and restart with zero data loss. |
| `backup.sh` | Create a timestamped backup of your database and logos. |
| `restore.sh` | Restore database and logos from a backup archive. |
| `stop.sh` | Manage the container: `stop`, `start`, `restart`, `logs`, `status`. |

## Common Workflows

### First deploy
```bash
./deploy-compose.sh
```

### Update to latest version
```bash
./update.sh
```

### Backup before updating
```bash
./backup.sh                    # creates ./backups/5dv-backup-<timestamp>.tar.gz
./update.sh                    # safe to update now
```

### Restore from backup
```bash
./restore.sh ./backups/5dv-backup-20260101-120000.tar.gz
```

### Check status & view logs
```bash
./stop.sh status
./stop.sh logs
```

### Stop and start
```bash
./stop.sh stop
./stop.sh start
```

## Data Locations

| Path | Contents |
|---|---|
| `db/` | SQLite database (subscriptions, users, settings) |
| `logos/` | Uploaded subscription logos |
| `backups/` | Created by `backup.sh` |

## Requirements

- Docker 20+ (or Docker Compose v2 for compose scripts)
- No other dependencies — everything runs in the container
