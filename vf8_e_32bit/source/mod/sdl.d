module mod.sdl;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl;


struct
Mod_sdl {
    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case INIT            : _init (evt); break;
            default              :
        }
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_QUIT        : _do_sdl_quit    (evt); break;
            case SDL_KEYDOWN     : _do_sdl_keydown (evt); break;
            default              :
        }
    }

    void
    _init (Event* evt) {
        import vf.sdl.init_sdl : init_sdl;
        init_sdl ();
    }

    void
    _do_sdl_quit (Event* evt) {
        with (evt.sdl.quit) {
            evt.o.quit = true;
        }
    }   

    void
    _do_sdl_keydown (Event* evt) {
        import vf.sdl.importc_sdl;
        // SDL_KEYDOWN
        // SDL_KEYUP
        with (evt.o)
        with (evt.sdl.key)
        switch (keysym.scancode) {
            case SDL_SCANCODE_ESCAPE : quit = true; break;
            case SDL_SCANCODE_Q      : quit = true; break;
            default                  :
        }
    }

    struct
    _Event {
        Type type;

        union {
            //
        }

        alias SDL_Event = .SDL_Event;

        enum
        Type {
            SDL_,
            // SDL_EventType...
        }
    }
}
