# Minecraft 26.1.2 NeoForge Server (Docker)

A modded Minecraft server running on `itzg/minecraft-server` with automatic backups via `itzg/mc-backup`.

## Features

- **Minecraft Version:** 26.1.2 (Java Edition)
- **Mod Loader:** NeoForge
- **RAM:** 8GB
- **Mode:** Survival
- **Online Mode:** Enabled (Mojang auth required)
- **Whitelist:** Disabled (enable when ready)
- **Command Blocks:** Enabled
- **Backups:** Every 30 minutes, stored in `./backups/`
- **Backup Retention:** 7 days (automatically pruned)

## Quick Start

### 1. Start the Server

```bash
docker compose up -d
```

### 2. View Logs

```bash
docker compose logs -f mc
```

### 3. Stop the Server

```bash
docker compose down
```

## Mods Setup

1. Place NeoForge mod `.jar` files into the `./mods/` directory.
2. Restart the server:

```bash
docker compose restart mc
```

### Recommended Mods for Your Server

The following mods are **client-side only** and do **not** need to be installed on the server:

- **Distant Horizons** - LOD render distance
- **Iris Shaders** - Shader support
- **Sodium** - Rendering optimization

These mods **must** be installed on the server:

- **WorldEdit** - In-game map editor
- **Effortless Building** - Bulk building tools

### Important: 26.2 Compatibility Warning

Minecraft 26.1.2 is the latest stable version with full NeoForge and mod support.

## Whitelist Setup

You must add players to the whitelist before they can join.

### Option A: Via RCON (Recommended)

```bash
docker compose exec mc rcon-cli whitelist add Steve
docker compose exec mc rcon-cli whitelist add Alex
```

### Option B: Via `whitelist.json`

Edit `./data/whitelist.json` and add player names:

```json
[
  {
    "uuid": "",
    "name": "Steve"
  }
]
```

Then reload:

```bash
docker compose exec mc rcon-cli whitelist reload
```

## Operator (OP) Commands

To give a player operator permissions (cheats/commands):

```bash
docker compose exec mc rcon-cli op Steve
```

## Backups

Backups run automatically every **30 minutes** via the `mc-backups` sidecar container.

### Backup Details

- **Location:** `./backups/`
- **Format:** Compressed `.tar.gz` archives
- **Retention:** 7 days (old backups are auto-deleted)
- **Method:** Server is paused during backup (save-off, flush, save-on)

### Manual Backup

```bash
docker compose exec mc-backups backup now
```

### Restore from Backup

1. Stop the server:
   ```bash
   docker compose down
   ```
2. Remove or move the current world data:
   ```bash
   mv ./data/world ./data/world_backup
   ```
3. Extract the desired backup from `./backups/` into `./data/`.
4. Start the server:
   ```bash
   docker compose up -d
   ```

## Configuration

Edit `docker-compose.yml` to change server settings:

| Variable | Default | Description |
|----------|---------|-------------|
| `VERSION` | `26.2` | Minecraft version |
| `MEMORY` | `8G` | Server RAM |
| `MODE` | `survival` | Game mode |
| `DIFFICULTY` | `normal` | Difficulty |
| `MAX_PLAYERS` | `20` | Max concurrent players |
| `MOTD` | `Minecraft 26.2 Modded Server` | Server message |
| `BACKUP_INTERVAL` | `30m` | Backup frequency |
| `PRUNE_BACKUPS_DAYS` | `7` | Backup retention |

## File Structure

```
mc-server/
├── docker-compose.yml      # Server and backup configuration
├── data/                   # Persistent server data (worlds, configs, whitelist)
├── mods/                   # NeoForge mods (.jar files)
└── backups/                # Automatic backups (created on first run)
```

## Troubleshooting

### Server won't start

```bash
# Check logs
docker compose logs mc

# Common issues:
# - Mod conflict -> check logs and remove problematic mods
# - Wrong mod loader -> ensure mods match NeoForge
```

### Can't connect to server

- Ensure port `25565` is open in your firewall
- Ensure `ONLINE_MODE: "TRUE"` requires valid Minecraft accounts
- Ensure client and server mods use the same mod loader (NeoForge)

### Backups not running

```bash
# Check backup container logs
docker compose logs backups

# Ensure mc container is healthy
docker compose ps
```

## Useful Commands

```bash
# Access server console
docker attach mc-server
# (Detach with Ctrl+P, Ctrl+Q)

# Run any server command
docker compose exec mc rcon-cli say Hello

# Check server status
docker compose exec mc rcon-cli list

# View server stats
docker compose exec mc rcon-cli tps

# Save world manually
docker compose exec mc rcon-cli save-all
```

## Docker Compose Cheatsheet

```bash
# Start everything
docker compose up -d

# Stop everything
docker compose down

# Restart server
docker compose restart mc

# Pull latest images
docker compose pull

# Update and restart
docker compose up -d

# View resource usage
docker stats
```

---

**Note:** This setup is designed to run on Linux. For Windows, use WSL2 or Docker Desktop.
