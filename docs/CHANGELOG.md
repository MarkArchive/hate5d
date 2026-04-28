# changelog (häte5d)

all notable changes to this project will be documented here.  
format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).  
versioning follows [Semantic Versioning](https://semver.org/).

---

## [0.1.0]: 2026

### Added

**Core (`core/common.nim`)**
- `HateResult[T]`: generic result type used across all fallible operations
- `HateContext`: top-level engine state (settings, windows, loop control, deltaTime)
- `HateInternalSettings`: game metadata (name, ID, version, type, genre)
- `HateSettingType`: enum controlling Injektion/mod behavior (`hstRelease`, `hstModble`, `hstBetterModble`, `hstOpen`)
- `WindowInfoMake`: window descriptor holding SDL2 pointers and frame logic
- `WindowState`: enum (`wsActive`, `wsMinimized`, `wsHidden`, `wsDestroyed`)
- `Object`: base game object with position, size, visibility, and optional sprite
- `ObjectType`: enum (`otSingleSprite`, `otSpriteSheet`, `otNonImage`, `otStrange`, `otAny`)
- `GameGenre`: enum for game categorization
- `COMPILE_SALT`: compile-time unix timestamp to prevent Game ID collisions
- `HATE_VER` constant
- `noww()`: current unix timestamp as `int64`
- `versionCompare()`: semver string comparison
- `randomStr()`: random alphanumeric string generator

**SDL2 binding (`core/sdl2.nim`)**
- manual SDL2 binding covering: init/quit, window management, renderer, textures, surfaces, events, timing
- `SdlWindow`, `SdlRenderer`, `SdlTexture`, `SdlSurface` as `pointer` types
- `SdlRect`, `SdlColor`, `SdlEvent` and sub-event types with C struct mapping
- Event constants: `SDL_QUIT`, `SDL_KEYDOWN`, `SDL_KEYUP`, `SDL_MOUSEMOTION`, `SDL_MOUSEBUTTONDOWN`, `SDL_MOUSEBUTTONUP`
- Common keycodes: arrows, escape, space, return, W, S
- Window flags: `SDL_WINDOW_SHOWN`, `SDL_WINDOW_INVISIBLE`, `SDL_WINDOW_RESIZABLE`, `SDL_WINDOW_BORDERLESS`, `SDL_WINDOW_FULLSCREEN`
- Renderer flags: `SDL_RENDERER_ACCELERATED`, `SDL_RENDERER_PRESENTVSYNC`
- Helper procs: `rectOf()`, `colorOf()`, `sdlCheck()`
- `imgLoad()` binding for SDL2_image

**Window module (`modules/window.nim`)**
- `genericWin()`: default frame logic (dark background + red rectangle placeholder)
- `initGenericWindow()`: returns a placeholder `WindowInfoMake` with nil SDL pointers
- `initWindow()`: creates SDL window and renderer, returns fully initialized `WindowInfoMake`
- `configWindow()`: unified window config: rename, clear renderer, destroy, resize
- `translateStateToSdl()`: converts `WindowState` to SDL2 flag

**Render module (`modules/render.nim`)**
- `initFrame()`: clears renderer with black background
- `endFrame()`: presents frame to screen
- `setBackground()`: clears with custom RGB color
- `setDrawColor()`: sets current draw color
- `drawRect()`: unfilled rectangle outline
- `drawFillRect()`: filled rectangle
- `drawLine()`: line between two points
- `drawSprite()`: loads image from disk and renders it, returns `HateResult[SdlTexture]`
- `loadTexture()`: loads image and returns texture without rendering
- `genericRenderer()`: placeholder renderer proc

**DD module (`modules/dd.nim`)**
- `createObject()`: constructs an `Object` with defaults
- `drawObject()`: renders an object (placeholder rect if no sprite, sprite if img is set)
- `unloadTexture()`: safely destroys a `SdlTexture`
- `deleteObject()`: destroys texture associated with an object

**Entry point (`hatelib.nim`)**
- Unified import: `import hatelib` exposes all modules

---

### Known limitations in v0.1.0

- Texture caching not implemented: `drawSprite` loads from disk on every call
- `Object` does not store its `SdlTexture`: planned for v0.1.1
- No input system
- No scene manager
- No animation system
- No camera
- Multi-window runs sequentially (no Micreads thread system)
- Injektion not implemented
- hatex CLI not started
- Rage Bait registry not started

---

## [0.1.0]: 2026

### Added
- `Object` gains `tex: SdlTexture` field
- Texture cache: load once, reuse across frames
- `drawSprite` uses cached texture instead of loading from disk

## [Unreleased]: planned

(versions without subversions can have future subversions)

### v0.1.2
- Partial input keyboard system (get `chars`)
- Pool events
- Partial input system (`mouse`)

### v0.1.3
- Simple scene manager (uncomment somethings in `common.nim`, without multi-scene)
- Loads (`loadScene`, `unloadScene`)

### v0.1.4
- Simple animation maneger (`SpriteFrame`, `Animation`)

### v0.1.5
- (simple) Injektion module

### v0.2.0
- Complete input system (`KeyState`, `InputAxis`)
- Scene manager (`Scene`)
- Basic animation support (`Animation`, `SpriteFrame`)

### v0.3.0
- injektion (mod loading system)
- `hstModble` and `hstBetterModble` enforcement

### future
- micreads: per-window threading
- camera system
- DDD: 3D rendering via OpenGL/Vulkan
- hatex CLI
- Rage Bait P2P registry
- HAS: the engine's own dev tool, itself a häte game