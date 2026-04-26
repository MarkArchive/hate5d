# häte5d-engine/_src/module/dd.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
import ../core/[common, sdl2]
import options, random
import render

randomize()

# desenha um objeto
proc drawObject*(obj: Object, win: WindowInfoMake): HateResult[bool] = 
    # não reclama, vai reclamar de que?
    if not obj.visible: return HateResult[bool](ok: true, val: true)
    
    # desenha algo genérico quando não tem sprite
    if obj.img.isNone: return drawFillRect(win, obj.x.int32, obj.y.int32, obj.w.int32, obj.h.int32)
    
    # usa o sprite do objeto
    else: return drawSprite(win, obj.img.get(), obj.x.int32, obj.y.int32, obj.w.int32, obj.h.int32)

# drawObject cria uma texture, tá, mas ela não é retornada
# o loadTexture faz o papel de rodar a imagem para criar o SdlTexture
# por enquanto, vai ser isso, na v0.1.1, Object vai ter uma parte específica para isso
proc loadTexture*(win: WindowInfoMake, path: string): HateResult[SdlTexture] =
    if win.sdlRen == nil:
        return HateResult[SdlTexture](ok: false, err: "no renderer")
    
    let sur = imgLoad(path.cstring)
    if sur == nil:
        return HateResult[SdlTexture](ok: false, err: "failed to load: " & path)
    
    let tex = sdlCreateTextureFromSurface(win.sdlRen, sur)
    sdlFreeSurface(sur)
    if tex == nil:
        return HateResult[SdlTexture](ok: false, err: "failed to create texture")
    
    return HateResult[SdlTexture](ok: true, val: tex)

proc unloadTexture*(tex: SdlTexture) =
    if tex != nil: sdlDestroyTexture(tex)

proc deleteObject*(obj: Object, win: WindowInfoMake) =
    if obj.img.isSome:
        let res = loadTexture(win, obj.img.get())
        if res.ok: sdlDestroyTexture(res.val)

proc createObject*(
    name : string,
    tipo : ObjectType = otAny,
    id   : int64,
    x, y : int = 0,
    w, h : int = 32,
    img  : Option[string] = none(string)
): Object =
    return Object(
        name    : name,
        id      : id,
        tipo    : tipo,
        x       : x,
        y       : y,
        w       : w,
        h       : h,
        visible : true,
        img     : img
    )