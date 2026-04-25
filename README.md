# häte5d

> by [markarchive](docs/markarchive.md)

> a lightweight, moddable 2D game engine for Nim (built around programmability, not meta-programming)

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL_v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![Nim](https://img.shields.io/badge/Nim-2.0%2B-yellow)](https://nim-lang.org)
![Status](https://img.shields.io/badge/status-early%20dev-red)

---

## what is häte5d?

häte5d is a 2D game engine for Nim focused on programmability and mod support.
unlike visual editors, everything in häte is code: no drag-and-drop, no node graphs (like löve2D)

key ideas:
- **injektion**: a first-class mod system built into the engine
- **hatex**: CLI tooling for building, publishing, and finding games
- **rage bait**: a pp2p (pseudo p2p) game registry for häte games (planned)
- **has**: the engine's own dev tool, itself a häte game
- **micreads**: multi threading window (it's literally that)

---

## status

> **WARM**: häte5d is in early development. The API will change without notice (or with notice if you read [changes](docs/CHANGELOG.md)).

| Module     | Status      |
|------------|-------------|
| core       | in progress |
| window     | in progress |
| render     | in progress |
| dd (objects) | in progress |
| Injektion  | planned  |
| hatex      | planned  |
| Rage Bait  | planned  |

---

## dependencies

- [Nim](https://nim-lang.org) (obviously) 2.0+
- SDL2
- SDL2_image

on Arch/RebornOS (my OS):
```bash
sudo pacman -S sdl2 sdl2_image
```

on Ubuntu/Debian:
```bash
sudo apt install libsdl2-dev libsdl2-image-dev
```

---

## getting started

```nim
import hatelib

let win = initWindow("my game") # creates a window

while true:
    # ya, i hate 2 spaces indentation
    discard initFrame(win)
    discard drawFillRect(win, 100, 100, 64, 64)
    discard endFrame(win)
```

---

## project structure
```
häte5d
├── docs
│   ├── CHANGELOG.md
│   ├── docs.md
│   └── markarchive.md
├── README.md
└── _src
    ├── core
    │   ├── common.nim
    │   ├── logic.nim
    │   └── sdl2.nim
    ├── hate5d.nimble
    ├── hatelib.nim
    └── modules
        ├── dd.nim
        ├── render.nim
        └── window.nim
```

## license
LGPL 3.0 (see [LICENSE](LICENSE).)
Games made with häte5d are **not** required to be open source.