module vf.sdl.log_event;

import vf.sdl.importc_sdl;


void
log_event (SDL_Event* evt) {
    import std.stdio : writefln;
    import vf.sdl.importc_sdl;

    with (evt)
    switch (type) with (SDL_EventType) {
        case SDL_MOUSEMOTION : break;
        case SDL_MOUSEWHEEL  : writefln ("%s %s %+s", cast (SDL_EventType)type, cast (SDL_MouseWheelDirection) wheel.direction, wheel.y); break;
        case SDL_WINDOWEVENT : writefln ("%s %d %s ", cast (SDL_EventType)type, window.windowID, cast (SDL_WindowEventID) window.event); break;
        case SDL_KEYDOWN     : writefln ("%s %s", cast (SDL_EventType)type, key.keysym.scancode); break;
        case SDL_KEYUP       : writefln ("%s %s", cast (SDL_EventType)type, key.keysym.scancode); break;
        default              :
            if (type < SDL_USEREVENT)
                writefln ("%s", cast (SDL_EventType) type);    
            else
                writefln ("%s", type);
    }
}

