# häte5d-engine/_src/module/render.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
import ../core/[common, sdl2]

proc initFrame*(win: WindowInfoMake): HateResult[bool] =
    if win.sdlWin == nil or win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "window without sdlWin or sdlRen")
    
    discard sdlSetRenderDrawColor(win.sdlRen, 0, 0, 0, 255)
    discard sdlRenderClear(win.sdlRen)
    return HateResult[bool](ok: true, val: true)

proc endFrame*(win: WindowInfoMake): HateResult[bool] =
    if win.sdlWin == nil or win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "window without sdlWin or sdlRen")
    
    sdlRenderPresent(win.sdlRen)
    return HateResult[bool](ok: true, val: true)

proc genericRenderer*(win: WindowInfoMake) =
    var rect = SdlRect(x: 100, y: 100, w: 320, h: 430)
    discard initFrame(win)
    discard sdlRenderFillRect(win.sdlRen, addr rect)

# cor de fundo customizável
proc setBackground*(win: WindowInfoMake, r, g, b: uint8): HateResult[bool] =
    if win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "no renderer")
    
    discard sdlSetRenderDrawColor(win.sdlRen, r, g, b, 255)
    discard sdlRenderClear(win.sdlRen)
    return HateResult[bool](ok: true, val: true)

# desenha retângulo outline
proc drawRect*(win: WindowInfoMake, x, y, w, h: int32): HateResult[bool] =
    if win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "no renderer")
    
    var r = rectOf(x, y, w, h)
    discard sdlRenderDrawRect(win.sdlRen, addr r)
    return HateResult[bool](ok: true, val: true)

# desenha retângulo preenchido
proc drawFillRect*(win: WindowInfoMake, x, y, w, h: int32): HateResult[bool] =
    if win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "no renderer")
    
    var r = rectOf(x, y, w, h)
    discard sdlRenderFillRect(win.sdlRen, addr r)
    return HateResult[bool](ok: true, val: true)

# desenha linha
proc drawLine*(win: WindowInfoMake, x1, y1, x2, y2: int32): HateResult[bool] =
    if win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "no renderer")
    
    discard sdlRenderDrawLine(win.sdlRen, x1, y1, x2, y2)
    return HateResult[bool](ok: true, val: true)

# seta a cor de draw atual (afeta drawRect, drawLine, etc)
proc setDrawColor*(win: WindowInfoMake, r, g, b: uint8, a: uint8 = 255): HateResult[bool] =
    if win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "no renderer")
    
    discard sdlSetRenderDrawColor(win.sdlRen, r, g, b, a)
    return HateResult[bool](ok: true, val: true)

# draw sprite básico (imagem inteira sem recorte)
proc drawSprite*(win: WindowInfoMake, path: string, x, y, w, h: int32): HateResult[bool] =
    if win.sdlRen == nil:
        return HateResult[bool](ok: false, err: "no renderer")
    
    let sur = imgLoad(path.cstring)
    if sur == nil:
        return HateResult[bool](ok: false, err: "failed to load: " & path)
    
    let tex = sdlCreateTextureFromSurface(win.sdlRen, sur)
    sdlFreeSurface(sur)
    if tex == nil:
        return HateResult[bool](ok: false, err: "failed to create texture: " & path)
    
    var dst = rectOf(x, y, w, h)
    discard sdlRenderCopy(win.sdlRen, tex, nil, addr dst)
    sdlDestroyTexture(tex)
    return HateResult[bool](ok: true, val: true)