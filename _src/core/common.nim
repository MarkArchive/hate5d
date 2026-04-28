# häte5d-engine/_src/core/common.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
import options, times, strutils, math, random
import sdl2

randomize()

const
    HATE_VER* = "0.1.0"
    # aqui vai ser mais pra v0.1.1 ou v0.1.2
#[     MAX_OBJECTS*        = 1024      # objetos por janela
    MAX_WINDOWS*        = 16        # janelas simultâneas
    MAX_SCENES*         = 64        # scenes por jogo
    MAX_ANIMATIONS*     = 256       # animações por janela
    CHANNEL_CAPACITY*   = 128       # mensagens no canal micreads ]#
    CHARSET*            = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

when defined(windows):
    const COMPILE_SALT* = staticExec("powershell -Command \"[DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()\"")
else:
    const COMPILE_SALT* = staticExec("date +%s%N") # impede que dois jogos com mesmo nome e versão tenham mesmo ID

var randomInitialized {.global.} = false

type
    # window manager
#[     WindowType* = enum
        wtNormal, wtNoBack, wtNoWindow,
        wtTranslucid, wtClippyLike, wtSystem # janelas System são mais pro hate
 ]#
    WindowState* = enum
        wsActive, wsMinimized, wsHidden, wsDestroyed

    WindowInfoMake* = object
        name*: string
        #id*: int64           # eu recomendo usar um número simples (ex.: 1, 4, 6)
        #tipo*: WindowType
        state*: WindowState
        logic*: proc(r: SdlRenderer)    # é o que tem dentro da window
        #mcable*: bool          # se o micreads pode ser conectado a essa janela
        #zIndex*: int           # ordem de renderização entre janelas
        x*, y*: int          # posição inicial
        w*, h*: int          # tamanho inicial
        sdlWin*: SdlWindow   # pointer
        sdlRen*: SdlRenderer # pointer

    # game stuff
    ObjectType* = enum
        otSingleSprite, otSpriteSheet,
        otNonImage, otStrange, otAny 
        # any é um objeto genérico (sem tipo especifico)
        # strange é um que muda

    Object* = object
        name*       : string
        id*         : int64
        tipo*       : ObjectType
        #[ winId*      : int64        # ID da janela que o objeto existe ]#
        x*, y*      : int
        w*, h*      : int
        visible*    : bool
        img*        : Option[string] # caso seja um sprite
        tex*        : SdlTexture     # guarda sua textura

#[     ObjectDDD* = object
        name*       : string
        id*         : int64
        winId*      : int64
        x*, y, z*   : int
        w*, h*      : int
        visible*    : bool
        img*        : string # obrigatório ter uma texture, se não tiver, fica com uma cor aleatória ]#

#[     Camera* = object
        name*   : string
        winId*  : int64
        id*     : int # hate decide isso
        x*, y*  : int ]#

#[     # para o caso do objeto ser otSpriteSheet
    SpriteFrame* = object
        x*, y*, w*, h*: int

    Animation* = object
        name*   : string
        frames* : seq[SpriteFrame]
        fps*    : int
        loop*   : bool

    InputAxis* = object
        x*, y*: float

    KeyState* = enum
        ksUp, ksDown, ksHeld

    # scene manager
    Scene* = object
        content*: seq[Object]
        anim*: seq[Animation]
        winId*: int64 ]#

    # outros
    GameGenre* = enum
        ggUnknown, ggRPG, ggPlatformer, ggCard,
        ggPointClick, ggShooter, ggVisualNovel, ggOther

    HateResult*[T] = object
        ok* : bool
        val*: T
        err*: string

    HateSettingType* = enum
        hstRelease, hstBetterModble, hstModble, hstOpen
        # realease = injektion e modificadores OFICIAIS não funcionam
        # modble = injektion e modificadores funcionam sem possibilidade de alterar o código
        # bettermodble = mesmo que modble, só que só funciona com mods assinados
        # open = mesmo que modble, só que é open source

    HateInternalSettings* = object
        gname*  : string
        id*     : string # sim, o ID do jogo (hate define isso, hash)
        version* = HATE_VER
        tipo*   : HateSettingType
        genre*  : GameGenre

    HateContext* = object
        settings*: HateInternalSettings
        windows*: seq[WindowInfoMake]
        running*: bool
        deltaTime*: float

# micro lógica
proc noww*(): int64 =
    return epochTime().int64

proc versionCompare*(a, b: string): int =
    let av = a.split('.')
    let bv = b.split('.')
    for i in 0..2:
        let diff = av[i].parseInt - bv[i].parseInt
        if diff != 0: return cmp(diff, 0)
    return 0

proc randomStr*(len: int): string =
    if not randomInitialized:
        randomize()
        randomInitialized = true
    result = newString(len)
    
    for i in 0 ..< len:
        result[i] = CHARSET[rand(CHARSET.len - 1)]