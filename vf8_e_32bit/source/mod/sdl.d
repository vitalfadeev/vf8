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
            case SDL_MOUSEWHEEL      : sdl_mousewheel          (&evt.wheel); break;
            case SDL_MOUSEBUTTONDOWN : sdl_mousebuttondown     (&evt.button); break;
            case SDL_MOUSEBUTTONUP   : sdl_mousebuttonup       (&evt.button); break;
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
    sdl_mousebuttondown (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt) {
            // Page with window
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;
            
            foreach (page; pages) {
                if (page.window._sdl_window == _sdl_window) {
                    page.sdl_mousebuttondown (evt);
                }
            }        
        }
    }    

    void
    sdl_mousebuttonup (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt) {
            // Page with window
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;
            
            foreach (page; pages) {
                if (page.window._sdl_window == _sdl_window) {
                    page.sdl_mousebuttonup (evt);
                }
            }        
        }
    }    

    void
    sdl_mousewheel (SDL_MouseWheelEvent* evt) {
        with (o)
        with (evt) {
            // Page with window
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;
            
            foreach (page; pages) {
                if (page.window._sdl_window == _sdl_window) {
                    page.sdl_mousewheel (evt);
                }
            }        
        }
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

