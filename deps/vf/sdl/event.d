module vf.sdl.event;

import vf.sdl.importc :
    SDL_Event,SDL_EventType,SDL_Scancode,
    SDL_BUTTON_LEFT,SDL_BUTTON_MIDDLE,SDL_BUTTON_RIGHT,
    SDL_BUTTON_X1,SDL_BUTTON_X2;

struct
Event {
    mixin (enum_event_type!("Type", SDL_EventType, Custon_EventType));

union {
    Type        type;
    Base        base;
    version (THORVG) Draw draw;
    SDL_Event   sdl;
}

    this (Type         typ) { type   = typ; }
    version (THORVG) this (Draw evt) { draw = evt; }

    string
    toString () {
        import std.format;
        return format!"%s(%s)" (typeof(this).stringof, type);
    }

    struct
    Base {
        Type type;
        void* o;
    }

    version (THORVG)
    struct
    Draw {
        import vf.sdl.importc_tvg : Tvg_Canvas;
        Type type = Type.DRAW;
        Tvg_Canvas canvas;
    }
}

string
enum_event_type (string NAME,T1,T2) () {
    return 
        "enum " ~ NAME ~ " {\n" ~
        _enum_event_type!(T1,T2)() ~
        "}";
}
string
_enum_event_type (T1,T2) () {
    import std.traits : EnumMembers;
    import std.conv   : to;

    string s;
    foreach (i,member; EnumMembers!T1)  {
        if ((cast(uint)member) < 0x8000)
            s ~= __traits(identifier,EnumMembers!T1[i]) ~ " = " ~ (cast(uint)member).to!string ~ ",\n";
    }
    foreach (i,member; EnumMembers!T2)  {
        if ((cast(uint)member) >= 0x8000)
            s ~= __traits(identifier,EnumMembers!T2[i]) ~ " = " ~ (cast(uint)member).to!string ~ ",\n";
    }
    return s;
}


enum
Custon_EventType {
    USEREVENT              = 0x8000, //SDL_EventType.SDL_USEREVENT,
    OPEN,
    DO_1,
    DO_FORCED,
    CLOSE,
    QUIT,
    // renderer
    DRAW,
    //
    SDL_LASTEVENT          = 0xFFFF, //SDL_EventType.SDL_LASTEVENT,
}
