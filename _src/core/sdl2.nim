# häte5d-engine/_src/core/sdl2.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
# binding manual do SDL2 (só o que presta)

{.passL: "-lSDL2".}

const
    SDL_INIT_VIDEO* = 0x00000020'u32
    SDL_INIT_AUDIO* = 0x00000010'u32
    SDL_INIT_EVENTS* = 0x00004000'u32
    SDL_INIT_EVERYTHING* = 0x0000FFFF'u32

    SDL_WINDOWPOS_CENTERED* = 0x2FFF0000'i32
    SDL_WINDOWPOS_UNDEFINED* = 0x1FFF0000'i32

    SDL_WINDOW_SHOWN* = 0x00000004'u32
    SDL_WINDOW_INVISIBLE* = 0'u32
    SDL_WINDOW_RESIZABLE* = 0x00000020'u32
    SDL_WINDOW_BORDERLESS* = 0x00000010'u32
    SDL_WINDOW_FULLSCREEN* = 0x00000001'u32

    SDL_RENDERER_ACCELERATED* = 0x00000002'u32
    SDL_RENDERER_PRESENTVSYNC* = 0x00000004'u32

    # eventos
    SDL_QUIT* = 0x100'u32
    SDL_KEYDOWN* = 0x300'u32
    SDL_KEYUP* = 0x301'u32
    SDL_MOUSEMOTION* = 0x400'u32
    SDL_MOUSEBUTTONDOWN* = 0x401'u32
    SDL_MOUSEBUTTONUP* = 0x402'u32

    # keycodes comuns
    SDLK_UP* = 1073741906'i32
    SDLK_DOWN* = 1073741905'i32
    SDLK_LEFT* = 1073741904'i32
    SDLK_RIGHT* = 1073741903'i32
    SDLK_ESCAPE* = 27'i32
    SDLK_SPACE* = 32'i32
    SDLK_RETURN* = 13'i32
    SDLK_w* = 119'i32
    SDLK_a* = 97'i32  
    SDLK_s* = 115'i32
    SDLK_d* = 100'i32

type
    SdlWindow* = pointer
    SdlRenderer* = pointer
    SdlTexture* = pointer
    SdlSurface* = pointer

    SdlRect* {.importc: "SDL_Rect", header: "<SDL2/SDL.h>".} = object
        x*, y*, w*, h*: int32

    SdlColor* {.importc: "SDL_Color", header: "<SDL2/SDL.h>".} = object
        r*, g*, b*, a*: uint8

    # evento simplificado (cobre os casos do hate)
    SdlKeysym* {.importc: "SDL_Keysym", header: "<SDL2/SDL.h>".} = object
        sym*: int32

    SdlKeyboardEvent* {.importc: "SDL_KeyboardEvent", header: "<SDL2/SDL.h>".} = object
        typ* {.importc: "type".}: uint32
        timestamp*: uint32
        windowID*: uint32
        state*: uint8
        repeat*: uint8
        scancode*: int32
        keysym* {.importc: "keysym".}: SdlKeysym

    SdlMouseMotionEvent* {.importc: "SDL_MouseMotionEvent", header: "<SDL2/SDL.h>".} = object
        typ* {.importc: "type".}: uint32
        timestamp*: uint32
        windowID*: uint32
        x*, y*: int32
        xrel*, yrel*: int32

    SdlMouseButtonEvent* {.importc: "SDL_MouseButtonEvent", header: "<SDL2/SDL.h>".} = object
        typ* {.importc: "type".}: uint32
        timestamp*: uint32
        windowID*: uint32
        button*: uint8
        state*: uint8
        x*, y*: int32

    SdlQuitEvent* {.importc: "SDL_QuitEvent", header: "<SDL2/SDL.h>".} = object
        typ* {.importc: "type".}: uint32
        timestamp*: uint32

    SdlEvent* {.importc: "SDL_Event", header: "<SDL2/SDL.h>", union.} = object
        typ* {.importc: "type".}: uint32
        key*: SdlKeyboardEvent
        motion*: SdlMouseMotionEvent
        button*: SdlMouseButtonEvent
        quit*: SdlQuitEvent

# init / quit
proc sdlInit*(flags: uint32): int32
    {.importc: "SDL_Init", header: "<SDL2/SDL.h>".}

proc sdlQuit*()
    {.importc: "SDL_Quit", header: "<SDL2/SDL.h>".}

proc sdlGetError*(): cstring
    {.importc: "SDL_GetError", header: "<SDL2/SDL.h>".}

# janelas
proc sdlCreateWindow*(title: cstring, x, y, w, h: int32, flags: uint32): SdlWindow
    {.importc: "SDL_CreateWindow", header: "<SDL2/SDL.h>".}

proc sdlDestroyWindow*(win: SdlWindow)
    {.importc: "SDL_DestroyWindow", header: "<SDL2/SDL.h>".}

proc sdlSetWindowTitle*(win: SdlWindow, title: cstring)
    {.importc: "SDL_SetWindowTitle", header: "<SDL2/SDL.h>".}

proc sdlSetWindowSize*(win: SdlWindow, w, h: int32)
    {.importc: "SDL_SetWindowSize", header: "<SDL2/SDL.h>".}

proc sdlGetWindowID*(win: SdlWindow): uint32
    {.importc: "SDL_GetWindowID", header: "<SDL2/SDL.h>".}

# renderer
proc sdlCreateRenderer*(win: SdlWindow, index: int32, flags: uint32): SdlRenderer
    {.importc: "SDL_CreateRenderer", header: "<SDL2/SDL.h>".}

proc sdlDestroyRenderer*(ren: SdlRenderer)
    {.importc: "SDL_DestroyRenderer", header: "<SDL2/SDL.h>".}

proc sdlRenderClear*(ren: SdlRenderer): int32
    {.importc: "SDL_RenderClear", header: "<SDL2/SDL.h>".}

proc sdlRenderPresent*(ren: SdlRenderer)
    {.importc: "SDL_RenderPresent", header: "<SDL2/SDL.h>".}

proc sdlSetRenderDrawColor*(ren: SdlRenderer, r, g, b, a: uint8): int32
    {.importc: "SDL_SetRenderDrawColor", header: "<SDL2/SDL.h>".}

proc sdlRenderCopy*(ren: SdlRenderer, tex: SdlTexture, src, dst: ptr SdlRect): int32
    {.importc: "SDL_RenderCopy", header: "<SDL2/SDL.h>".}

proc sdlRenderFillRect*(ren: SdlRenderer, rect: ptr SdlRect): int32
    {.importc: "SDL_RenderFillRect", header: "<SDL2/SDL.h>".}

proc sdlRenderDrawRect*(ren: SdlRenderer, rect: ptr SdlRect): int32
    {.importc: "SDL_RenderDrawRect", header: "<SDL2/SDL.h>".}

proc sdlRenderDrawLine*(ren: SdlRenderer, x1, y1, x2, y2: int32): int32
    {.importc: "SDL_RenderDrawLine", header: "<SDL2/SDL.h>".}

proc sdlRenderDrawPoint*(ren: SdlRenderer, x, y: int32): int32
    {.importc: "SDL_RenderDrawPoint", header: "<SDL2/SDL.h>".}

proc sdlSetTextureBlendMode*(tex: SdlTexture, mode: int32): int32
    {.importc: "SDL_SetTextureBlendMode", header: "<SDL2/SDL.h>".}

proc sdlSetTextureAlphaMod*(tex: SdlTexture, a: uint8): int32
    {.importc: "SDL_SetTextureAlphaMod", header: "<SDL2/SDL.h>".}

proc sdlSetTextureColorMod*(tex: SdlTexture, r, g, b: uint8): int32
    {.importc: "SDL_SetTextureColorMod", header: "<SDL2/SDL.h>".}

# texturas
proc sdlCreateTexture*(ren: SdlRenderer, format: uint32, access, w, h: int32): SdlTexture
    {.importc: "SDL_CreateTexture", header: "<SDL2/SDL.h>".}

proc sdlDestroyTexture*(tex: SdlTexture)
    {.importc: "SDL_DestroyTexture", header: "<SDL2/SDL.h>".}

proc sdlQueryTexture*(tex: SdlTexture, format: ptr uint32, access, w, h: ptr int32): int32
    {.importc: "SDL_QueryTexture", header: "<SDL2/SDL.h>".}

proc sdlLoadBMP*(path: cstring): SdlSurface
    {.importc: "SDL_LoadBMP", header: "<SDL2/SDL.h>".}

# converte Surface em Texture
proc sdlCreateTextureFromSurface*(ren: SdlRenderer, sur: SdlSurface): SdlTexture
    {.importc: "SDL_CreateTextureFromSurface", header: "<SDL2/SDL.h>".}

# libera a surface depois de virar texture
proc sdlFreeSurface*(sur: SdlSurface)
    {.importc: "SDL_FreeSurface", header: "<SDL2/SDL.h>".}

proc imgLoad*(path: cstring): SdlSurface
    {.importc: "IMG_Load", header: "<SDL2/SDL_image.h>".}

# eventos
proc sdlPollEvent*(event: ptr SdlEvent): int32
    {.importc: "SDL_PollEvent", header: "<SDL2/SDL.h>".}

proc sdlWaitEvent*(event: ptr SdlEvent): int32
    {.importc: "SDL_WaitEvent", header: "<SDL2/SDL.h>".}

# timing
proc sdlGetTicks*(): uint32
    {.importc: "SDL_GetTicks", header: "<SDL2/SDL.h>".}

proc sdlDelay*(ms: uint32)
    {.importc: "SDL_Delay", header: "<SDL2/SDL.h>".}

# helpers Nim (não são SDL2, são conveniência do hate)
proc sdlCheck*(code: int32, msg: string) =
    if code < 0: raise newException(IOError, msg & ": " & $sdlGetError())

proc rectOf*(x, y, w, h: int32): SdlRect =
    SdlRect(x: x, y: y, w: w, h: h)

proc colorOf*(r, g, b: uint8, a: uint8 = 255'u8): SdlColor =
    SdlColor(r: r, g: g, b: b, a: a)