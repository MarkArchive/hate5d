# häte5d  Documentation
> version 0.1.0 | LGPL 3.0 | MarkArchive/devdeco

---

## overview

häte5d is a 2D game engine for Nim built around programmability. There is no visual editor, no node graph, no drag-and-drop (everything is code). The engine is designed with mod support as a first-class feature, not an afterthought.

This document covers the public API of `hatelib` as of v0.1.0.

---

## importing

```nim
import hatelib
```

this gives you access to all modules: `common`, `sdl2`, `window`, `render`, and `dd`.

---

## core (`core/common.nim`)

### constants

| Name | Value | Description |
|------|-------|-------------|
| `HATE_VER` | `"0.1.0"` | current engine version |
| `CHARSET` | a-z A-Z 0-9 | used by `randomStr` |
| `COMPILE_SALT` | unix timestamp (compile-time) | prevents ID collisions between games with same name/version |

### types

#### `WindowState`
```nim
WindowState* = enum
    wsActive, wsMinimized, wsHidden, wsDestroyed
```

#### `WindowInfoMake`
the main window descriptor. Holds both the SDL2 pointers and the window's logic proc.

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | window title |
| `state` | `WindowState` | current state |
| `logic` | `proc(r: SdlRenderer)` | frame logic (called every frame) |
| `x`, `y` | `int` | Initial position |
| `w`, `h` | `int` | Initial size |
| `sdlWin` | `SdlWindow` | Internal SDL window pointer |
| `sdlRen` | `SdlRenderer` | Internal SDL renderer pointer |

#### `ObjectType`
```nim
ObjectType* = enum
    otSingleSprite, otSpriteSheet,
    otNonImage, otStrange, otAny
```
- `otAny`: generic object with no specific type
- `otStrange`: object whose type changes at runtime

#### `Object`
| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | object identifier |
| `id` | `int64` | unique ID (set by `createObject`) |
| `tipo` | `ObjectType` | object category |
| `x`, `y` | `int` | position |
| `w`, `h` | `int` | size |
| `visible` | `bool` | whether to render |
| `img` | `Option[string]` | path to sprite image, if any |
| `tex` | `SdlTexture` | texture of img (real sprite) |

#### `HateResult[T]`
return type used across the engine for fallible operations.

```nim
HateResult[T] = object
    ok  : bool
    val : T
    err : string
```

Usage:
```nim
let res = drawFillRect(win, 0, 0, 64, 64)
if not res.ok:
    echo res.err
```

#### `HateSettingType`
controls mod/injektion behavior for a game.

| Value | Description |
|-------|-------------|
| `hstRelease` | injektion and official modifiers disabled |
| `hstModble` | injektion enabled, no code modification |
| `hstBetterModble` | same as Modble, but only signed mods work |
| `hstOpen` | full mod support, open source mode |

#### `HateContext`
top-level engine state. Holds settings, windows, and loop info.

| Field | Type | Description |
|-------|------|-------------|
| `settings` | `HateInternalSettings` | game metadata |
| `windows` | `seq[WindowInfoMake]` | active windows |
| `running` | `bool` | loop control flag |
| `deltaTime` | `float` | Time between frames |

#### `GameGenre`
```nim
GameGenre* = enum
    ggUnknown, ggRPG, ggPlatformer, ggCard,
    ggPointClick, ggShooter, ggVisualNovel, ggOther
```

### procs

#### `noww(): int64`
Returns current unix timestamp as `int64`.

#### `versionCompare(a, b: string): int`
Compares two semver strings. Returns negative, zero, or positive.

```nim
assert versionCompare("0.2.0", "0.1.0") > 0
```

#### `randomStr(len: int): string`
Returns a random alphanumeric string of given length.

---

## module (`modules/window.nim`)

### `genericWin(ren: SdlRenderer)`
default window logic. Draws a dark background with a red rectangle. Used as fallback when no logic is provided.

### `initGenericWindow(): WindowInfoMake`
returns a `WindowInfoMake` with `genericWin` as logic and nil SDL pointers. useful as a placeholder before spawning a real window.

### `initWindow(name, logic, x, y, w, h): WindowInfoMake`
creates a real SDL window and renderer. Returns a fully initialized `WindowInfoMake`.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `name` | `"dumbwindow"` | window title |
| `logic` | `nil` -> `genericWin` | frame logic proc |
| `x`, `y` | `100`, `100` | screen position |
| `w`, `h` | `320`, `240` | window size |

raises `IOError` if SDL window or renderer creation fails.

### `configWindow(win, wdo, arg, arg1, arg2): HateResult[bool]`
multi-purpose window configuration proc.

| `wdo` value | Effect | Uses |
|-------------|--------|------|
| `"name"` | sets window title | `arg: string` |
| `"clearren"` | clears the renderer | - |
| `"dontscream"` | Destroys window and renderer |  |
| `"resize"` | Resizes window | `arg1, arg2: int32` |

### `translateStateToSdl(s: WindowState): uint32`
converts a `WindowState` to the corresponding SDL2 flag.

---

## module (`modules/render.nim`)

all draw procs require a valid `WindowInfoMake` with non-nil `sdlRen`. the typical frame pattern is:

```nim
discard initFrame(win)
# draw calls here
discard endFrame(win)
```

### `initFrame(win): HateResult[bool]`
clears the renderer with a black background. call at the start of every frame.

### `endFrame(win): HateResult[bool]`
presents the rendered frame to the screen. call at the end of every frame.

### `setBackground(win, r, g, b): HateResult[bool]`
sets background color and clears. call instead of `initFrame` when you want a custom background color.

### `setDrawColor(win, r, g, b, a): HateResult[bool]`
sets the current draw color for subsequent primitives.

### `drawRect(win, x, y, w, h): HateResult[bool]`
Draws an unfilled rectangle outline.

### `drawFillRect(win, x, y, w, h): HateResult[bool]`
Draws a filled rectangle.

### `drawLine(win, x1, y1, x2, y2): HateResult[bool]`
Draws a line between two points.

### `drawSprite(win, path, x, y, w, h): HateResult[SdlTexture]`
loads an image from disk and draws it at the given position and size. Returns the created `SdlTexture`  caller is responsible for destroying it with `unloadTexture` when done.

### `loadTexture(win, path): HateResult[SdlTexture]`
loads an image and returns the texture without drawing. Use when you need the texture handle directly (v0.1.1: you just use drawObject and createObject, loadTexture is for internal).

---

## module (`modules/dd.nim`)

### `createObject(name, tipo, x, y, w, h, img): Object`
creates a new `Object` with the given parameters.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `name` |  | object name |
| `tipo` | `otAny` | object type |
| `x`, `y` | `0`, `0` | position |
| `w`, `h` | `32`, `32` | size |
| `img` | `none(string)` | sprite path |
| `win` | `WindowInfoMake` | window |

### `drawObject(obj, win): HateResult[bool]`
draws an object. if `visible` is false, returns ok silently. if `tex` is none, draws a filled rectangle placeholder. if `tex` is none and `img` is set, create texture and add to `Object`.

### `unloadTexture(tex: SdlTexture)`
safely destroys a texture. Checks for nil before calling SDL.

### `deleteObject(obj, win)`
destroys the texture associated with an object's sprite, if any.

---

## game loop example

```nim
import hatelib

proc myLogic(ren: SdlRenderer) =
    discard sdlSetRenderDrawColor(ren, 255, 0, 0, 255)
    var r = rectOf(50, 50, 100, 100)
    discard sdlRenderFillRect(ren, addr r)

let win = initWindow("my game", myLogic)
var obj = createObject("player", otSingleSprite, 10, 10, 32, 32, some("player.png"))

while true:
    discard initFrame(win)
    discard drawObject(obj, win)
    discard endFrame(win)
```

---

## What is NOT in v0.1.1

The following are planned but not yet implemented:

- **Injektion**: mod system
- **Micreads**: per-window thread system
- **Scene manager**: `Scene`, `Animation`, `SpriteFrame`
- **Camera system**: []
- **Input system**: `KeyState`, `InputAxis`
- **Multi-window manager**: `WindowType`, `zIndex`
- **DDD**: 3D rendering backend
- **hatex**: CLI tooling
- **Rage Bait**: P2P game registry
- **Texture cache**: currently loads from disk every frame

---

*häte5d is developed by MarkArchive/devdeco. Licensed under LGPL 3.0.*