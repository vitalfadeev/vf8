module mod.sdl;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.wm : Wm;


struct
Mod_sdl (O) {
    O* o;

    void
    DO_SWITCH (Event* evt) {
        log_event (evt);

        with (o)
        switch (evt.type) with (SDL_EventType) {
            case SDL_QUIT            : hub.SDL_QUIT            (&evt.quit); break;
            case SDL_KEYDOWN         : hub.SDL_KEYDOWN         (&evt.key); break;
            case SDL_KEYUP           : hub.SDL_KEYUP           (&evt.key); break;
            case SDL_MOUSEWHEEL      : hub.SDL_MOUSEWHEEL      (&evt.wheel); break;
            case SDL_MOUSEBUTTONDOWN : hub.SDL_MOUSEBUTTONDOWN (&evt.button); break;
            case SDL_MOUSEBUTTONUP   : hub.SDL_MOUSEBUTTONUP   (&evt.button); break;
            case SDL_WINDOWEVENT     : hub.SDL_WINDOWEVENT     (&evt.window); break;
            default                  :
        }
    }

    void
    INIT () {
        import vf.sdl.init_sdl : init_sdl;
        init_sdl ();
    }

    void
    SDL_QUIT (SDL_QuitEvent* evt) {
        o.quit = true;
    }   

    void
    SDL_KEYDOWN (SDL_KeyboardEvent* evt) {
        // SDL_KEYDOWN
        // SDL_KEYUP
        with (o)
        with (evt)
        switch (keysym.scancode) {
            case SDL_SCANCODE_ESCAPE : o.quit = true; break;
            case SDL_SCANCODE_Q      : o.quit = true; break;
            default                  :
        }
    }
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

