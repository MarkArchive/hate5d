# häte5d-engine/core/char.nim
# eu ia botar no sdl2, mas pelo amor né
# vai ser separado mesmo

const
    # copiei o sdl2 mesmo e cabo
    SDL_SCANCODE_MASK*  = (1 shl 30).int32

template SDLK_SCANCODE_TO_KEYCODE*(x: int32): int32 = 
    x or SDL_SCANCODE_MASK

const
    # alfabeto inteiro minúsculo
    SDLSK_a* = ord('a').int32
    SDLSK_b* = ord('b').int32
    SDLSK_c* = ord('c').int32
    SDLSK_d* = ord('d').int32
    SDLSK_e* = ord('e').int32
    SDLSK_f* = ord('f').int32
    SDLSK_g* = ord('g').int32
    SDLSK_h* = ord('h').int32
    SDLSK_i* = ord('i').int32
    SDLSK_j* = ord('j').int32
    SDLSK_k* = ord('k').int32
    SDLSK_l* = ord('l').int32
    SDLSK_m* = ord('m').int32
    SDLSK_n* = ord('n').int32
    SDLSK_o* = ord('o').int32
    SDLSK_p* = ord('p').int32
    SDLSK_q* = ord('q').int32
    SDLSK_r* = ord('r').int32
    SDLSK_s* = ord('s').int32
    SDLSK_t* = ord('t').int32
    SDLSK_u* = ord('u').int32
    SDLSK_v* = ord('v').int32
    SDLSK_w* = ord('w').int32
    SDLSK_x* = ord('x').int32
    SDLSK_y* = ord('y').int32
    SDLSK_z* = ord('z').int32

    # números
    SDLSK_0* = ord('0').int32
    SDLSK_1* = ord('1').int32
    SDLSK_2* = ord('2').int32
    SDLSK_3* = ord('3').int32
    SDLSK_4* = ord('4').int32
    SDLSK_5* = ord('5').int32
    SDLSK_6* = ord('6').int32
    SDLSK_7* = ord('7').int32
    SDLSK_8* = ord('8').int32
    SDLSK_9* = ord('9').int32

    # símbolos comuns
    SDLSK_SPACE*      = ord(' ').int32
    SDLSK_EXCLAIM*    = ord('!').int32
    SDLSK_QUOTEDBL*   = ord('"').int32
    SDLSK_HASH*       = ord('#').int32
    SDLSK_DOLLAR*     = ord('$').int32
    SDLSK_PERCENT*    = ord('%').int32
    SDLSK_AMPERSAND*  = ord('&').int32
    SDLSK_QUOTE*      = ord('\'').int32
    SDLSK_LEFTPAREN*  = ord('(').int32
    SDLSK_RIGHTPAREN* = ord(')').int32
    SDLSK_ASTERISK*   = ord('*').int32
    SDLSK_PLUS*       = ord('+').int32
    SDLSK_COMMA*      = ord(',').int32
    SDLSK_MINUS*      = ord('-').int32
    SDLSK_PERIOD*     = ord('.').int32
    SDLSK_SLASH*      = ord('/').int32
    SDLSK_COLON*      = ord(':').int32
    SDLSK_SEMICOLON*  = ord(';').int32
    SDLSK_LESS*       = ord('<').int32
    SDLSK_EQUALS*     = ord('=').int32
    SDLSK_GREATER*    = ord('>').int32
    SDLSK_QUESTION*   = ord('?').int32
    SDLSK_AT*         = ord('@').int32
    SDLSK_LEFTBRACKET*  = ord('[').int32
    SDLSK_BACKSLASH*    = ord('\\').int32
    SDLSK_RIGHTBRACKET* = ord(']').int32
    SDLSK_CARET*        = ord('^').int32
    SDLSK_UNDERSCORE*   = ord('_').int32
    SDLSK_BACKQUOTE*    = ord('`').int32

    # controles básicos
    SDLSK_RETURN*    = 13'i32
    SDLSK_ESCAPE*    = 27'i32
    SDLSK_BACKSPACE* = 8'i32
    SDLSK_TAB*       = 9'i32
    SDLSK_DELETE*    = 127'i32

    # scancodes pra depois dar mask
    SDL_SCANCODE_F1*  = 58'i32
    SDL_SCANCODE_F2*  = 59'i32
    SDL_SCANCODE_F3*  = 60'i32
    SDL_SCANCODE_F4*  = 61'i32
    SDL_SCANCODE_F5*  = 62'i32
    SDL_SCANCODE_F6*  = 63'i32
    SDL_SCANCODE_F7*  = 64'i32
    SDL_SCANCODE_F8*  = 65'i32
    SDL_SCANCODE_F9*  = 66'i32
    SDL_SCANCODE_F10* = 67'i32
    SDL_SCANCODE_F11* = 68'i32
    SDL_SCANCODE_F12* = 69'i32

    SDL_SCANCODE_RIGHT* = 79'i32
    SDL_SCANCODE_LEFT*  = 80'i32
    SDL_SCANCODE_DOWN*  = 81'i32
    SDL_SCANCODE_UP*    = 82'i32

    SDL_SCANCODE_LCTRL*  = 224'i32
    SDL_SCANCODE_LSHIFT* = 225'i32
    SDL_SCANCODE_LALT*   = 226'i32
    SDL_SCANCODE_LGUI*   = 227'i32

    SDL_SCANCODE_RCTRL*  = 228'i32
    SDL_SCANCODE_RSHIFT* = 229'i32
    SDL_SCANCODE_RALT*   = 230'i32
    SDL_SCANCODE_RGUI*   = 231'i32

    # maskarados
    SDLSK_F1*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F1)
    SDLSK_F2*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F2)
    SDLSK_F3*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F3)
    SDLSK_F4*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F4)
    SDLSK_F5*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F5)
    SDLSK_F6*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F6)
    SDLSK_F7*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F7)
    SDLSK_F8*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F8)
    SDLSK_F9*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F9)
    SDLSK_F10* = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F10)
    SDLSK_F11* = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F11)
    SDLSK_F12* = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F12)

    SDLSK_RIGHT* = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RIGHT)
    SDLSK_LEFT*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LEFT)
    SDLSK_DOWN*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_DOWN)
    SDLSK_UP*    = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_UP)

    SDLSK_LCTRL*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LCTRL)
    SDLSK_LSHIFT* = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LSHIFT)
    SDLSK_LALT*   = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LALT)
    SDLSK_LGUI*   = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LGUI)

    SDLSK_RCTRL*  = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RCTRL)
    SDLSK_RSHIFT* = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RSHIFT)
    SDLSK_RALT*   = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RALT)
    SDLSK_RGUI*   = SDLK_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RGUI)