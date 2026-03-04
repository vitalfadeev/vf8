module mod.sdl_wm;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;


struct
Mod_sdl_wm (O) {
    O* o;

    void
    INIT () {
        //
    }

    //void
    //SDL_KEYDOWN (SDL_KeyboardEvent* evt) {
    //    // SDL_KEYDOWN
    //    // SDL_KEYUP
    //    with (o)
    //    with (evt)
    //    switch (keysym.scancode) {
    //        case SDL_SCANCODE_ESCAPE : o.quit = true; break;
    //        case SDL_SCANCODE_Q      : o.quit = true; break;
    //        default                  :
    //    }
    //}
}

void
log_event (Event* evt) {
    import std.stdio : writefln;
    import vf.sdl.importc_sdl;

    with (SDL_EventType)
    if (evt.sdl.type == SDL_MOUSEMOTION)
        {}
    else
    if (evt.sdl.type == SDL_MOUSEWHEEL)
        writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, cast (SDL_MouseWheelDirection) evt.sdl.wheel.direction);
    else
    if (evt.sdl.type == SDL_WINDOWEVENT)
        writefln ("%s %d %s ", cast (SDL_EventType)evt.sdl.type, evt.sdl.window.windowID, cast (SDL_WindowEventID) evt.sdl.window.event);
    else
    if (evt.sdl.type == SDL_KEYDOWN)
        writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, evt.sdl.key.keysym.scancode);
    else
    if (evt.sdl.type == SDL_KEYUP)
        writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, evt.sdl.key.keysym.scancode);
    else
    if (evt.sdl.type < SDL_USEREVENT)
        writefln ("%s", cast (SDL_EventType) evt.sdl.type);    
    else
        writefln ("%s", evt.type);
}

