# Architecture Overview

The generator is organized into three primary layers:

1. **UI Layer** — collects parameters and triggers generation
2. **Generation Layer** — produces an abstract layout (rooms, tiles, terrain, etc.)
3. **Visualization Layer** — renders the resulting layout into a Godot TileMap

---

## Flow

When the user clicks **GO**:

UI -> Generate(config) -> Layout -> Render(TileMapLayer)

This pipeline is driven by `GenerationHandler.gd`.

---

## Responsibilities

### **UI Layer** (`GenerationHandler.gd`)

**Responsibilities**

- Displays controls and parameters
- Builds the configuration object for generation
- Invokes the selected generator

**Does Not**

- Render tiles directly
- Implement generation algorithms

---

### **Generation Layer** (`DungeonGenerator.gd` and subclasses)

**Responsibilities**

- Runs the selected algorithm based on provided parameters
- Produces an abstract `GameMap` layout
- Defines `map` contents via cell types (`FloorCell.gd`, `WallCell.gd`, etc.)

**Does Not**

- Instantiate sprites or Godot nodes
- Access UI controls

The `GameMap.gd` data structure serves as the generation output contract between generation and visualization.

---

### **Visualization Layer** (`GenerationHandler.gd` / `TileMapLayer`)

**Responsibilities**

- Converts `GameMap` data into a rendered tilemap
- Clears previously generated content before redraw

---

## Data Model

**Inputs:**

- Generation parameters: map sizes, room count, room sizes, noise settings, algorithm selection, etc.

**Output:**

- `GameMap` layout containing:
  - `map` (grid/cell data)
  - cell objects (`FloorCell`, `WallCell`, etc.)

The visualization layer only requires the final `GameMap` object, allowing algorithms to vary without changing rendering logic.

---

## Limitations

Current known limitations include:

- **Not deterministic** — no seed-based reproduction
- **Single-threaded** — runs on the main thread
- **Visualization coupling** — tile rendering currently tied to a specific tileset

---

## Future Extensions

Planned improvements and potential expansion areas:

- Seed-based reproduction for debugging and reproducibility
- Step-through algorithm playback and inspection
- Exporting generated layouts for external projects or gameplay use
