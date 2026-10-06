# Infinite Map

A Fabric mod for Minecraft 1.16.5 that makes Filled Maps behave like truly infinite maps. The map automatically centers on the player and updates in a radius of up to 1000 blocks, even when those chunks are outside the normal render distance.

## What it does

- **Continuous updates** — when you walk past the edge of the map, it does not stay blank; it pulls in new terrain data instead
- **Auto-centering** — the map center follows the player every tick, so while flying with an elytra or moving fast the map always shows the area around you
- **Extended scan radius** — the mod preloads chunks in a 1000-block spiral around the player to reduce empty zones

## Installation

1. Install **Fabric Loader 0.14+** and **Fabric API 0.42+** for Minecraft 1.16.5
2. Download `infinitemap-1.0.0.jar` from [releases](../../releases)
3. Drop it into your `mods/` folder
4. Launch the game

## Requirements

- Minecraft 1.16.5
- Fabric Loader 0.14+
- Fabric API 0.42+
- Java 8

## Building from source

```bash
./gradlew build
```

The output jar will be in `build/libs/infinitemap-1.0.0.jar`.

## Limitations

Map updates beyond render distance depend on the server's `view-distance`. If the server uses a small view distance, the map may still show empty areas far from the player even with this mod. That requires a server-side change.

## License

MIT
