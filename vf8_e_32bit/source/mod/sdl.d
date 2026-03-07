module mod.sdl;

version (SDL):
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.log_event : log_event;
import app : o;


struct
Sdl {
    void
    DO_SWITCH (SDL_Event* evt) {
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

