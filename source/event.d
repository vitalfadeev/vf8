module event;

import importc: 
    SDL_Event,SDL_EventType,SDL_Scancode,
    SDL_BUTTON_LEFT,SDL_BUTTON_MIDDLE,SDL_BUTTON_RIGHT,
    SDL_BUTTON_X1,SDL_BUTTON_X2;

struct
Event {
union {
    Type             type;
    SDL_Event        sdl;
    //
    Event_base       base;
    Event_open       open;
    Event_quit       quit;
    Event_draw       draw;
    Event_play       play;
    Event_update     update;
    Event_set_e_prop set_e_prop;
    Event_layout     layout;
    Event_click      click;
    Event_press      press;
    Event_release    release;
    Event_hotkey     hotkey;
    Event_attrs      attrs;
}
    this (Type         typ) { type   = typ; }
    this (Event_play   evt) { play   = evt; }
    this (Event_click  evt) { click  = evt; }
    this (Event_hotkey evt) { hotkey = evt; }

    string
    toString () {
        import std.format;
        return format!"%s (%s)" (typeof(this).stringof, type);
    }

    enum
    Type : uint {
        _ = 0,
        //
        // SDL_EventType
        //
        // 32 bit
        // FFFF_FFFF
        //  SDL_SDLK_a = SDLK_a
        //                   0x100
        SDL_QUIT           = SDL_EventType.SDL_QUIT,
        //                   0x150
        DISPLAYEVENT       = SDL_EventType.SDL_DISPLAYEVENT,
        //                   0x200
        WINDOWEVENT        = SDL_EventType.SDL_WINDOWEVENT,
        SYSWMEVENT         = SDL_EventType.SDL_SYSWMEVENT,
        //                   0x300
        KEYDOWN            = SDL_EventType.SDL_KEYDOWN,
        KEYUP              = SDL_EventType.SDL_KEYUP,
        TEXTEDITING        = SDL_EventType.SDL_TEXTEDITING,
        TEXTINPUT          = SDL_EventType.SDL_TEXTINPUT,
        KEYMAPCHANGED      = SDL_EventType.SDL_KEYMAPCHANGED,
        TEXTEDITING_EXT    = SDL_EventType.SDL_TEXTEDITING_EXT,
        //                   0x400
        MOUSEMOTION        = SDL_EventType.SDL_MOUSEMOTION,
        MOUSEBUTTONDOWN    = SDL_EventType.SDL_MOUSEBUTTONDOWN,
        MOUSEBUTTONUP      = SDL_EventType.SDL_MOUSEBUTTONUP,
        MOUSEWHEEL         = SDL_EventType.SDL_MOUSEWHEEL,
        //                   0x700
        FINGERDOWN         = SDL_EventType.SDL_FINGERDOWN,
        FINGERUP           = SDL_EventType.SDL_FINGERUP,
        FINGERMOTION       = SDL_EventType.SDL_FINGERMOTION,
        //                   0x900
        CBOARDUPDATE       = SDL_EventType.SDL_CLIPBOARDUPDATE,
        //                   0x1000
        DROPFILE           = SDL_EventType.SDL_DROPFILE,
        DROPTEXT           = SDL_EventType.SDL_DROPTEXT,
        DROPBEGIN          = SDL_EventType.SDL_DROPBEGIN,
        DROPCOMPLETE       = SDL_EventType.SDL_DROPCOMPLETE,
        //                   0x1100
        AUDIODEVICEADDED   = SDL_EventType.SDL_AUDIODEVICEADDED,
        AUDIODEVICEREMOVED = SDL_EventType.SDL_AUDIODEVICEREMOVED,
        //                       0x8000
        USEREVENT              = SDL_EventType.SDL_USEREVENT,
        // ...
        //                       0x9000
        USEREVENT9000          = 0x9000,
        // ...
        //
        // Keys
        //                       0xA000
        USER_KEY_EVENT         = 0xA000,
        //KEY_A                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_A,
        //KEY_B                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_B,
        //KEY_C                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_C,
        //KEY_D                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_D,
        //KEY_E                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_E,
        //KEY_F                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F,
        //KEY_G                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_G,
        //KEY_H                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_H,
        //KEY_I                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_I,
        //KEY_J                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_J,
        //KEY_K                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_K,
        //KEY_L                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_L,
        //KEY_M                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_M,
        //KEY_N                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_N,
        //KEY_O                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_O,
        //KEY_P                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_P,
        //KEY_Q                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_Q,
        //KEY_R                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_R,
        //KEY_S                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_S,
        //KEY_T                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_T,
        //KEY_U                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_U,
        //KEY_V                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_V,
        //KEY_W                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_W,
        //KEY_X                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_X,
        //KEY_Y                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_Y,
        //KEY_Z                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_Z,
        //KEY_1                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_1,
        //KEY_2                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_2,
        //KEY_3                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_3,
        //KEY_4                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_4,
        //KEY_5                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_5,
        //KEY_6                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_6,
        //KEY_7                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_7,
        //KEY_8                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_8,
        //KEY_9                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_9,
        //KEY_0                  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_0,
        //KEY_RETURN             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RETURN,
        //KEY_ESCAPE             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_ESCAPE,
        //KEY_BACKSPACE          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_BACKSPACE,
        //KEY_TAB                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_TAB,
        //KEY_SPACE              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SPACE,
        //KEY_MINUS              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_MINUS,
        //KEY_EQUALS             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_EQUALS,
        //KEY_LEFTBRACKET        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LEFTBRACKET,
        //KEY_RIGHTBRACKET       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RIGHTBRACKET,
        //KEY_BACKSLASH          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_BACKSLASH,
        //KEY_NONUSHASH          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_NONUSHASH,
        //KEY_SEMICOLON          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SEMICOLON,
        //KEY_APOSTROPHE         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_APOSTROPHE,
        //KEY_GRAVE              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_GRAVE,
        //KEY_COMMA              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_COMMA,
        //KEY_PERIOD             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_PERIOD,
        //KEY_SLASH              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SLASH,
        //KEY_CAPSLOCK           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CAPSLOCK,
        //KEY_F1                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F1,
        //KEY_F2                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F2,
        //KEY_F3                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F3,
        //KEY_F4                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F4,
        //KEY_F5                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F5,
        //KEY_F6                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F6,
        //KEY_F7                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F7,
        //KEY_F8                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F8,
        //KEY_F9                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F9,
        //KEY_F10                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F10,
        //KEY_F11                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F11,
        //KEY_F12                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F12,
        //KEY_PRINTSCREEN        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_PRINTSCREEN,
        //KEY_SCROLLLOCK         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SCROLLLOCK,
        //KEY_PAUSE              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_PAUSE,
        //KEY_INSERT             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INSERT,
        //KEY_HOME               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_HOME,
        //KEY_PAGEUP             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_PAGEUP,
        //KEY_DELETE             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_DELETE,
        //KEY_END                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_END,
        //KEY_PAGEDOWN           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_PAGEDOWN,
        //KEY_RIGHT              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RIGHT,
        //KEY_LEFT               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LEFT,
        //KEY_DOWN               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_DOWN,
        //KEY_UP                 = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_UP,
        //KEY_NUMLOCKCLEAR       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_NUMLOCKCLEAR,
        //KEY_KP_DIVIDE          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_DIVIDE,
        //KEY_KP_MULTIPLY        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MULTIPLY,
        //KEY_KP_MINUS           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MINUS,
        //KEY_KP_PLUS            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_PLUS,
        //KEY_KP_ENTER           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_ENTER,
        //KEY_KP_1               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_1,
        //KEY_KP_2               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_2,
        //KEY_KP_3               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_3,
        //KEY_KP_4               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_4,
        //KEY_KP_5               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_5,
        //KEY_KP_6               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_6,
        //KEY_KP_7               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_7,
        //KEY_KP_8               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_8,
        //KEY_KP_9               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_9,
        //KEY_KP_0               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_0,
        //KEY_KP_PERIOD          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_PERIOD,
        //KEY_NONUSBACKSLASH     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_NONUSBACKSLASH,
        //KEY_APPLICATION        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_APPLICATION,
        //KEY_POWER              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_POWER,
        //KEY_KP_EQUALS          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_EQUALS,
        //KEY_F13                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F13,
        //KEY_F14                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F14,
        //KEY_F15                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F15,
        //KEY_F16                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F16,
        //KEY_F17                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F17,
        //KEY_F18                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F18,
        //KEY_F19                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F19,
        //KEY_F20                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F20,
        //KEY_F21                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F21,
        //KEY_F22                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F22,
        //KEY_F23                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F23,
        //KEY_F24                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_F24,
        //KEY_EXECUTE            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_EXECUTE,
        //KEY_HELP               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_HELP,
        //KEY_MENU               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_MENU,
        //KEY_SELECT             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SELECT,
        //KEY_STOP               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_STOP,
        //KEY_AGAIN              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AGAIN,
        //KEY_UNDO               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_UNDO,
        //KEY_CUT                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CUT,
        //KEY_COPY               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_COPY,
        //KEY_PASTE              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_PASTE,
        //KEY_FIND               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_FIND,
        //KEY_MUTE               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_MUTE,
        //KEY_VOLUMEUP           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_VOLUMEUP,
        //KEY_VOLUMEDOWN         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_VOLUMEDOWN,
        //KEY_KP_COMMA           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_COMMA,
        //KEY_KP_EQUALSAS400     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_EQUALSAS400,
        //KEY_INTERNATIONAL1     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL1,
        //KEY_INTERNATIONAL2     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL2,
        //KEY_INTERNATIONAL3     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL3,
        //KEY_INTERNATIONAL4     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL4,
        //KEY_INTERNATIONAL5     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL5,
        //KEY_INTERNATIONAL6     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL6,
        //KEY_INTERNATIONAL7     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL7,
        //KEY_INTERNATIONAL8     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL8,
        //KEY_INTERNATIONAL9     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_INTERNATIONAL9,
        //KEY_LANG1              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG1,
        //KEY_LANG2              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG2,
        //KEY_LANG3              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG3,
        //KEY_LANG4              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG4,
        //KEY_LANG5              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG5,
        //KEY_LANG6              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG6,
        //KEY_LANG7              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG7,
        //KEY_LANG8              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG8,
        //KEY_LANG9              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LANG9,
        //KEY_ALTERASE           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_ALTERASE,
        //KEY_SYSREQ             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SYSREQ,
        //KEY_CANCEL             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CANCEL,
        //KEY_CLEAR              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CLEAR,
        //KEY_PRIOR              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_PRIOR,
        //KEY_RETURN2            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RETURN2,
        //KEY_SEPARATOR          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SEPARATOR,
        //KEY_OUT                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_OUT,
        //KEY_OPER               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_OPER,
        //KEY_CLEARAGAIN         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CLEARAGAIN,
        //KEY_CRSEL              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CRSEL,
        //KEY_EXSEL              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_EXSEL,
        //KEY_KP_00              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_00,
        //KEY_KP_000             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_000,
        //KEY_THOUSANDSSEPARATOR = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_THOUSANDSSEPARATOR,
        //KEY_DECIMALSEPARATOR   = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_DECIMALSEPARATOR,
        //KEY_CURRENCYUNIT       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CURRENCYUNIT,
        //KEY_CURRENCYSUBUNIT    = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CURRENCYSUBUNIT,
        //KEY_KP_LEFTPAREN       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_LEFTPAREN,
        //KEY_KP_RIGHTPAREN      = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_RIGHTPAREN,
        //KEY_KP_LEFTBRACE       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_LEFTBRACE,
        //KEY_KP_RIGHTBRACE      = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_RIGHTBRACE,
        //KEY_KP_TAB             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_TAB,
        //KEY_KP_BACKSPACE       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_BACKSPACE,
        //KEY_KP_A               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_A,
        //KEY_KP_B               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_B,
        //KEY_KP_C               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_C,
        //KEY_KP_D               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_D,
        //KEY_KP_E               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_E,
        //KEY_KP_F               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_F,
        //KEY_KP_XOR             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_XOR,
        //KEY_KP_POWER           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_POWER,
        //KEY_KP_PERCENT         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_PERCENT,
        //KEY_KP_LESS            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_LESS,
        //KEY_KP_GREATER         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_GREATER,
        //KEY_KP_AMPERSAND       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_AMPERSAND,
        //KEY_KP_DBLAMPERSAND    = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_DBLAMPERSAND,
        //KEY_KP_VERTICALBAR     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_VERTICALBAR,
        //KEY_KP_DBLVERTICALBAR  = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_DBLVERTICALBAR,
        //KEY_KP_COLON           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_COLON,
        //KEY_KP_HASH            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_HASH,
        //KEY_KP_SPACE           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_SPACE,
        //KEY_KP_AT              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_AT,
        //KEY_KP_EXCLAM          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_EXCLAM,
        //KEY_KP_MEMSTORE        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MEMSTORE,
        //KEY_KP_MEMRECALL       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MEMRECALL,
        //KEY_KP_MEMCLEAR        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MEMCLEAR,
        //KEY_KP_MEMADD          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MEMADD,
        //KEY_KP_MEMSUBTRACT     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MEMSUBTRACT,
        //KEY_KP_MEMMULTIPLY     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MEMMULTIPLY,
        //KEY_KP_MEMDIVIDE       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_MEMDIVIDE,
        //KEY_KP_PLUSMINUS       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_PLUSMINUS,
        //KEY_KP_CLEAR           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_CLEAR,
        //KEY_KP_CLEARENTRY      = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_CLEARENTRY,
        //KEY_KP_BINARY          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_BINARY,
        //KEY_KP_OCTAL           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_OCTAL,
        //KEY_KP_DECIMAL         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_DECIMAL,
        //KEY_KP_HEXADECIMAL     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KP_HEXADECIMAL,
        //KEY_LCTRL              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LCTRL,
        //KEY_LSHIFT             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LSHIFT,
        //KEY_LALT               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LALT,
        //KEY_LGUI               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_LGUI,
        //KEY_RCTRL              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RCTRL,
        //KEY_RSHIFT             = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RSHIFT,
        //KEY_RALT               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RALT,
        //KEY_RGUI               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_RGUI,
        //KEY_MODE               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_MODE,
        //KEY_AUDIONEXT          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AUDIONEXT,
        //KEY_AUDIOPREV          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AUDIOPREV,
        //KEY_AUDIOSTOP          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AUDIOSTOP,
        //KEY_AUDIOPLAY          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AUDIOPLAY,
        //KEY_AUDIOMUTE          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AUDIOMUTE,
        //KEY_MEDIASELECT        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_MEDIASELECT,
        //KEY_WWW                = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_WWW,
        //KEY_MAIL               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_MAIL,
        //KEY_CALCULATOR         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CALCULATOR,
        //KEY_COMPUTER           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_COMPUTER,
        //KEY_AC_SEARCH          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AC_SEARCH,
        //KEY_AC_HOME            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AC_HOME,
        //KEY_AC_BACK            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AC_BACK,
        //KEY_AC_FORWARD         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AC_FORWARD,
        //KEY_AC_STOP            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AC_STOP,
        //KEY_AC_REFRESH         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AC_REFRESH,
        //KEY_AC_BOOKMARKS       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AC_BOOKMARKS,
        //KEY_BRIGHTNESSDOWN     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_BRIGHTNESSDOWN,
        //KEY_BRIGHTNESSUP       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_BRIGHTNESSUP,
        //KEY_DISPLAYSWITCH      = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_DISPLAYSWITCH,
        //KEY_KBDILLUMTOGGLE     = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KBDILLUMTOGGLE,
        //KEY_KBDILLUMDOWN       = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KBDILLUMDOWN,
        //KEY_KBDILLUMUP         = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_KBDILLUMUP,
        //KEY_EJECT              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_EJECT,
        //KEY_SLEEP              = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SLEEP,
        //KEY_APP1               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_APP1,
        //KEY_APP2               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_APP2,
        //KEY_AUDIOREWIND        = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AUDIOREWIND,
        //KEY_AUDIOFASTFORWARD   = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_AUDIOFASTFORWARD,
        //KEY_SOFTLEFT           = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SOFTLEFT,
        //KEY_SOFTRIGHT          = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_SOFTRIGHT,
        //KEY_CALL               = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_CALL,
        //KEY_ENDCALL            = USER_KEY_EVENT | SDL_Scancode.SDL_SCANCODE_ENDCALL,
        //KEY_NUM_SCANCODES      = USER_KEY_EVENT | SDL_Scancode.SDL_NUM_SCANCODES,        
        ////                       0xB000
        //USER_MOUSE_EVENT       = 0xB000,
        //BUTTON_LEFT            = USER_MOUSE_EVENT | SDL_BUTTON_LEFT,
        //BUTTON_MIDDLE          = USER_MOUSE_EVENT | SDL_BUTTON_MIDDLE,
        //BUTTON_RIGHT           = USER_MOUSE_EVENT | SDL_BUTTON_RIGHT,
        //BUTTON_X1              = USER_MOUSE_EVENT | SDL_BUTTON_X1,
        //BUTTON_X2              = USER_MOUSE_EVENT | SDL_BUTTON_X2,
        //
        USEREVENTC000          = 0xC000,
        // ...
        USEREVENTD000          = 0xD000,
        // ...
        USEREVENTE000          = 0xE000,
        // ...
        //                       0xF000
        APPREVENT              = 0xF000,
        //
        OPEN,
        QUIT,
        // video
        DRAW,
        REDRAW,
        // audio
        PLAY,
        PLAY_1,
        PLAY_2,
        PLAY_3,
        // ui
        UPDATE,
        SET_E_PROP,
        LAYOUT,
        CLICK,
        PRESS,
        RELEASE,
        HOTKEY_PRESS,
        HOTKEY_RELEASE,
        ATTRS,
        //                       0xFFFF
        SDL_LASTEVENT          = SDL_EventType.SDL_LASTEVENT,
    }
}
struct
Event_base {
    Event.Type type;
    void* o;
}
struct
Event_draw {
    Event.Type type = Event.Type.DRAW;
    import importc;
    Tvg_Canvas canvas;

    template
    tpl () {
        Color  _bg;
        Color  _fg;
        string text;
        alias Color = uint;
    }
    alias Color = uint;  // aabbggrr

    import importc;
    import layout;
    void
    draw_rect (Tvg_Canvas canvas, XY xy, XY wh, Color bg, Color fg) {
        ubyte fg_r = (fg >>  0) & 0xFF;
        ubyte fg_g = (fg >>  8) & 0xFF;
        ubyte fg_b = (fg >> 16) & 0xFF;
        ubyte fg_a = (fg >> 24) & 0xFF;

        ubyte bg_r = (bg >>  0) & 0xFF;
        ubyte bg_g = (bg >>  8) & 0xFF;
        ubyte bg_b = (bg >> 16) & 0xFF;
        ubyte bg_a = (bg >> 24) & 0xFF;

        Tvg_Paint shape = tvg_shape_new ();
        tvg_shape_append_rect (shape, xy.x, xy.y, wh.w, wh.h, 0.0f, 0.0f, true);
        tvg_shape_set_fill_color (shape, bg_r, bg_g, bg_b, bg_a);
        tvg_shape_set_stroke_width (shape, 1);
        tvg_shape_set_stroke_color (shape, fg_r, fg_g, fg_b, fg_a);

        //Push the shape into the canvas
        tvg_canvas_push (canvas, shape);
    }

    void
    draw_text (Tvg_Canvas canvas, XY xy, XY wh, string text) {
        {
            //import importc;

            //auto canvas = cast (Tvg_Canvas) d;

            ////
            //if (tvg_font_load (font_file.ptr) != TVG_RESULT_SUCCESS) {
            //    printf ("Problem with loading the font from the file. Did you enable TTF Loader?\n");
            //}

            //Tvg_Paint _text = tvg_text_new ();
            //tvg_text_set_font   (_text, font_name.ptr);
            //tvg_text_set_size   (_text, font_size);
            //tvg_text_set_color  (_text, font_color_r, font_color_g, font_color_b);
            //tvg_text_set_text   (_text, text.ptr);
            //tvg_paint_translate (_text, x, y);
            //tvg_canvas_push (canvas, _text);
        }
    }
}
struct
Event_click {
    auto type = Event.Type.CLICK;
    int  x;
    int  y;

    template
    tpl () {
        Event.Type on_click_send_evt_type;  // PLLAY
        int        on_click_send_evt_arg;   // 1
    }
}
struct
Event_press {
    auto type = Event.Type.PRESS;
    int  x;
    int  y;
}
struct
Event_release {
    auto type = Event.Type.RELEASE;
    int  x;
    int  y;
}
struct
Event_hotkey {
    auto type = Event.Type.HOTKEY_PRESS;
    void* e;
}
struct
Event_attrs {
    auto type = Event.Type.ATTRS;
    import attrs;
    mixin Attrs;
}

struct
Event_open {
    Event.Type type = Event.Type.OPEN;
}
struct
Event_quit {
    Event.Type type = Event.Type.QUIT;
}
struct
Event_play {
    Event.Type type = Event.Type.PLAY;
    int id;
}
struct
Event_update {
    auto type     = Event.Type.UPDATE;
    auto strategy = Strategy._;

    enum
    Strategy {
        _,
        wh,
        hw,
    }
}
struct
Event_set_e_prop {
    auto type = Event.Type.SET_E_PROP;
}
struct
Event_layout {
    auto  type = Event.Type.LAYOUT;
    // left
    float line_height = 64.0;

    template
    tpl () {
        mixin Xywh!E;
        mixin Layout!E;
    }
}
