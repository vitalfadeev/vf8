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
            case SDL_WINDOWEVENT : _do_sdl_window  (evt); break;
            case SDL_KEYDOWN     : _do_sdl_keydown (evt); break;
            default              :
        }
    }

    void
    _init (Event* evt) {
        //
    }

    void
    _do_sdl_quit (Event* evt) {
        with (evt.sdl.quit) {
            evt.o.quit = true;
        }
    }   

    void
    _do_sdl_window (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.window)
        switch (event) with (SDL_WindowEventID) {
            case SDL_WINDOWEVENT_CLOSE:
                break;
            case SDL_WINDOWEVENT_EXPOSED:
                import vf.sdl.renderer_sdl : Renderer;
                Renderer renderer;
                renderer.draw_start (&evt.sdl);
                send_now (DRAW, &renderer);
                renderer.draw_end (&evt.sdl);
                break;
            default:
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

        enum
        Type {
            __,
            // SDL_EventType...
        }
    }
}
