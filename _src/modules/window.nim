# häte5d-engine/_src/module/window.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
import ../core/[sdl2, common]

proc genericWin*(ren: SdlRenderer) =
    discard sdlSetRenderDrawColor(ren, 20, 20, 20, 255)
    discard sdlRenderClear(ren)

    discard sdlSetRenderDrawColor(ren, 180, 60, 60, 255)
    var r = rectOf(60, 60, 200, 120)
    discard sdlRenderDrawRect(ren, addr r)

    sdlRenderPresent(ren)

proc initGenericWindow*(): WindowInfoMake =
    return WindowInfoMake(
        name    : "nothing",
        state   : wsActive,
        logic   : genericWin,
        x       : 100,
        y       : 100,
        w       : 320,
        h       : 240,
        sdlWin  : nil,  # modifica depois
        sdlRen  : nil
    )

proc translateStateToSdl*(s: WindowState): uint32 =
    case s:
    of wsActive:        return SDL_WINDOW_SHOWN
    of wsMinimized:     return SDL_WINDOW_RESIZABLE
    of wsHidden:        return SDL_WINDOW_INVISIBLE
    else:               return 0

proc initWindow*(name: string = "dumbwindow", logic: proc(r: SdlRenderer) = nil): WindowInfoMake =
    let win = sdlCreateWindow(name.cstring, 100, 100, 320, 240, SDL_WINDOW_SHOWN)
    if win == nil: raise newException(IOError, "initWindow failed: " & $sdlGetError())

    let ren = sdlCreateRenderer(win, -1, SDL_RENDERER_ACCELERATED)
    if ren == nil:
        sdlDestroyWindow(win)
        # usa raise newException devido ao initWindow só retornar WindowInfoMake
        raise newException(IOError, "createRenderer (from initWindow) failed: " & $sdlGetError())

    let resolvedLogic =
        if logic == nil: genericWin
        else: logic

    return WindowInfoMake(
        name    : name,
        state   : wsActive,
        logic   : resolvedLogic,
        x       : 100,
        y       : 100,
        w       : 320,
        h       : 240,
        sdlWin  : win,
        sdlRen  : ren
    )

# quanta gambiarra
# ao invés de divir tudo em várias funções, fiz tudo em uma só
proc configWindow*(win: WindowInfoMake, wdo: string, arg: string = "", arg1: int32 = 0, arg2: int32 = 0): HateResult[bool] =
    if win.sdlWin == nil or win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "window without sdlWin or sdlRen")

    case wdo:
    of "name":
        sdlSetWindowTitle(win.sdlWin, arg.cstring)
    of "clearren":
        discard sdlRenderClear(win.sdlRen)
    of "dontscream":
        sdlDestroyRenderer(win.sdlRen)
        sdlDestroyWindow(win.sdlWin)
    of "resize":
        sdlSetWindowSize(win.sdlWin, arg1, arg2)
    else:
        return HateResult[bool](ok: false, err: "unknown op: " & wdo)

    return HateResult[bool](ok: true, val: true)