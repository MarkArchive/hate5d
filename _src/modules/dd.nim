# häte5d-engine/_src/module/dd.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
import ../core/[common, sdl2]
import options, random
import render

randomize()

# na v0.1.1, você não vai precisar usar o loadTexture
# apenas será utilizado de forma interna
proc loadTexture*(win: WindowInfoMake, path: string): HateResult[SdlTexture] =
    if win.sdlRen == nil:
        return fail("no renderer", SdlTexture(nil))
    
    let sur = imgLoad(path.cstring)
    if sur == nil:
        return fail("failed to load: ", SdlTexture(nil))
    
    let tex = sdlCreateTextureFromSurface(win.sdlRen, sur)
    sdlFreeSurface(sur)
    if tex == nil:
        return fail("failed to create texture", SdlTexture(nil))
    
    return ok(tex)

# desenha um objeto
proc drawObject*(obj: Object, win: WindowInfoMake): HateResult[bool] = 
    # não reclama, vai reclamar de que?
    if not obj.visible: return ok(true)
    
    if obj.tex != nil:
        # se ta carregado, usa direto
        var dst = rectOf(obj.x.int32, obj.y.int32, obj.w.int32, obj.h.int32)
        discard sdlRenderCopy(win.sdlRen, obj.tex, nil, addr dst)
        return ok(true)
    
    elif obj.tex == nil and obj.img.isSome:
        # se texture não existe, mas tem imagem, carrega uma vez e guarda
        let res = loadTexture(win, obj.img.get())
        if not res.ok: return fail($res.err, false)

        obj.tex = res.val
        var dst = rectOf(obj.x.int32, obj.y.int32, obj.w.int32, obj.h.int32)
        discard sdlRenderCopy(win.sdlRen, obj.tex, nil, addr dst)
        return ok(true)
    
    # retorna um genérico
    else: return drawFillRect(win, obj.x.int32, obj.y.int32, obj.w.int32, obj.h.int32)

proc unloadTexture*(tex: SdlTexture) = 
    if tex != nil: sdlDestroyTexture(tex)

proc deleteObject*(obj: Object, win: WindowInfoMake) =
    if obj.tex != nil:
        sdlDestroyTexture(obj.tex)
        obj.tex = nil

# cria um objeto completo (não um objeto genérico)
proc createObject*(
    name : string,
    tipo : ObjectType = otAny,
    id   : int64,
    x, y : int = 0,
    w, h : int = 32,
    img  : Option[string] = none(string),
    win  : WindowInfoMake
): Object =

    var imgload: SdlTexture = nil

    if img.isSome:
        let res = loadTexture(win, img.get())
        if res.ok: imgload = res.val

    return Object(
        name    : name,
        id      : id,
        tipo    : tipo,
        x       : x,
        y       : y,
        w       : w,
        h       : h,
        visible : true,
        img     : img,
        tex     : imgload
    )