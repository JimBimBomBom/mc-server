# Minecraft 26.1.2 NeoForge Server (Docker) - "Ashwake - Survival"

A modded Minecraft server running on `itzg/minecraft-server` with automatic
backups via `itzg/mc-backup`. The **Ashwake - Survival** world is tracked in Git
so it can be uploaded/downloaded between your local machine and the server.

## Features

- **Minecraft Version:** 26.1.2 (Java Edition)
- **Mod Loader:** NeoForge
- **World:** `Ashwake - Survival` (stored in `./world/`, loaded as level `world`)
- **RAM:** 8GB
- **Mode:** Survival
- **Online Mode:** Enabled (Mojang auth required)
- **Whitelist:** Disabled (enable when ready)
- **Backups:** Every 30 minutes, stored in `./backups/`
- **Backup Retention:** 7 days (automatically pruned)

## How the world is loaded

The itzg server uses `/data` as its data directory and loads the world named by
the `LEVEL` env var from `/data/<LEVEL>`. This repo:

- Sets `LEVEL: "world"` in `docker-compose.yml`.
- Bind-mounts the tracked `./world` folder to `/data/world`.

So the running server's live world **is** the Git-tracked `./world/` directory.
Editing/playing the world updates `./world/`, which you then commit and push.

```
mc-server/
├── docker-compose.yml      # Server + backup configuration
├── world/                  # "Ashwake - Survival" world  (TRACKED in git)
├── mods/                   # Server-side mods (downloaded, NOT in git)
│   └── download-mods.sh
├── data/                   # Server runtime: configs, logs  (NOT in git)
└── backups/                # Automatic backups             (NOT in git)
```

## Workflow: local <-> Git <-> server

### On your local machine (test first)

```bash
git pull
bash mods/download-mods.sh        # fetch server mods
docker compose up -d              # start + test
# ...play / verify the world loads...
docker compose down
git add -A && git commit -m "update world" && git push
```

### On the server (deploy)

```bash
git clone <repo-url> mc-server && cd mc-server   # first time
# OR:  git pull                                  # update
bash mods/download-mods.sh
docker compose up -d
```

> The world (`./world/`) is ~750 MB, so `git push`/`clone`/`pull` will move that
> data. Only commit the world when it has meaningfully changed.

## Quick Start

```bash
bash mods/download-mods.sh   # download server mods
docker compose up -d         # start server (+ backups)
docker compose logs -f mc    # watch logs
docker compose down          # stop
```

## Mods

Server-side mods are downloaded by `mods/download-mods.sh` (jars are gitignored):

- **WorldEdit** - in-game map editor
- **Effortless Building** - bulk building tools

Client-side only (do **not** install on the server):

- **Distant Horizons** - LOD render distance
- **Iris Shaders** - shader support
- **Sodium** - rendering optimization

To add a mod, edit `mods/download-mods.sh`, then:

```bash
bash mods/download-mods.sh
docker compose restart mc
```

## Whitelist Setup

```bash
# Via RCON (recommended)
docker compose exec mc rcon-cli whitelist add Steve
docker compose exec mc rcon-cli whitelist reload
```

To enable enforcement, set `ENABLE_WHITELIST: "TRUE"` in `docker-compose.yml`.

## Operator (OP)

```bash
docker compose exec mc rcon-cli op Steve
```

## Backups

Automatic every **30 minutes** via the `mc-backups` sidecar. Only the `world`
folder is backed up (`INCLUDES: "world"`).

- **Location:** `./backups/`  (gitignored)
- **Format:** `.tgz` archives
- **Retention:** 7 days (auto-pruned)

```bash
# Manual backup
docker compose exec mc-backups backup now
```

### Restore from a backup

```bash
docker compose down
mv ./world ./world_old
mkdir ./world
tar -xzf ./backups/<chosen-backup>.tgz -C ./world   # adjust path inside archive
docker compose up -d
```

## Configuration

Edit `docker-compose.yml`:

| Variable | Default | Description |
|----------|---------|-------------|
| `VERSION` | `26.1.2` | Minecraft version |
| `LEVEL` | `world` | World folder name under /data |
| `MEMORY` | `8G` | Server RAM |
| `MODE` | `survival` | Game mode |
| `DIFFICULTY` | `normal` | Difficulty |
| `MAX_PLAYERS` | `20` | Max concurrent players |
| `MOTD` | `Ashwake - Survival` | Server message |
| `BACKUP_INTERVAL` | `30m` | Backup frequency |
| `PRUNE_BACKUPS_DAYS` | `7` | Backup retention |

## Troubleshooting

### Server won't start / world won't load

```bash
docker compose logs mc
```

- The world was created in singleplayer with mods. The server only needs the
  server-side mods (WorldEdit, Effortless Building). Client mods like Distant
  Horizons are not required; their leftover data is ignored.
- Mod/loader mismatch -> ensure mods are NeoForge for 26.1.2.

### Can't connect

- Open port `25565` in the firewall.
- `ONLINE_MODE: "TRUE"` requires valid Minecraft accounts.

## Useful Commands

```bash
docker compose exec mc rcon-cli list      # who's online
docker compose exec mc rcon-cli save-all  # force save
docker compose exec mc rcon-cli say Hello
docker stats                              # resource usage
```

---

**Note:** Designed to run on Linux/Docker. On Windows, use Docker Desktop (WSL2).
