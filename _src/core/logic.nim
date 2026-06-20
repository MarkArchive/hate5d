# häte5d-engine/_src/core/logic.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
# esse modulo vai servir para o input em geral
# vai criar um pool events próprio (HatePool) e receber inputs no geral
# além de funcionar futuramente para animações (pool events resolve tudo)
# v0.1.1: essa versão é mais para ecs e o input de mouse (então não terá pool events)
import sdl2

# mouse/keyboard
proc mousePos*(): tuple[x, y: int32] =
    var x, y: int32

    discard sdlGetMouseState(addr x, addr y)
    return (x, y)

proc mouseLeft*(): bool =
    var x, y: int32
    
    let state = sdlGetMouseState(addr x, addr y)
    return (state and (1 shl (SDL_BUTTON_LEFT - 1))) != 0

proc mouseRight*(): bool =
    var x, y: int32
    
    let state = sdlGetMouseState(addr x, addr y)
    return (state and (1 shl (SDL_BUTTON_RIGHT - 1))) != 0

proc mouseMiddle*(): bool =
    var x, y: int32
    
    let state = sdlGetMouseState(addr x, addr y)
    return (state and (1 shl (SDL_BUTTON_MIDDLE - 1))) != 0