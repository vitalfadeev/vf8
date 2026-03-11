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
            case SDL_EVENT_QUIT                         : hub.SDL_EVENT_QUIT           (&evt.quit); break;
            case SDL_EVENT_KEY_DOWN                     : hub.SDL_EVENT_KEY_DOWN       (&evt.key); break;
            case SDL_EVENT_KEY_UP                       : hub.SDL_EVENT_KEY_UP         (&evt.key); break;
            case SDL_EVENT_MOUSE_WHEEL                  : sdl_event_mouse_wheel        (&evt.wheel); break;
            case SDL_EVENT_MOUSE_BUTTON_DOWN            : sdl_event_mouse_button_down  (&evt.button); break;
            case SDL_EVENT_MOUSE_BUTTON_UP              : sdl_event_mouse_button_up    (&evt.button); break;
            case SDL_EVENT_WINDOW_SHOWN                 : hub.SDL_EVENT_WINDOW_SHOWN   (&evt.window); break;
            case SDL_EVENT_WINDOW_EXPOSED               : hub.SDL_EVENT_WINDOW_EXPOSED (&evt.window); break;
            case SDL_EVENT_WINDOW_CLOSE_REQUESTED       : hub.SDL_EVENT_WINDOW_CLOSE_REQUESTED  (&evt.window); break;
            //case SDL_EVENT_WINDOW_HIDDEN                :
            //case SDL_EVENT_WINDOW_MOVED                 :
            //case SDL_EVENT_WINDOW_RESIZED               :
            //case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED    :
            //case SDL_EVENT_WINDOW_METAL_VIEW_RESIZED    :
            //case SDL_EVENT_WINDOW_MINIMIZED             :
            //case SDL_EVENT_WINDOW_MAXIMIZED             :
            //case SDL_EVENT_WINDOW_RESTORED              :
            //case SDL_EVENT_WINDOW_MOUSE_ENTER           :
            //case SDL_EVENT_WINDOW_MOUSE_LEAVE           :
            //case SDL_EVENT_WINDOW_FOCUS_GAINED          :
            //case SDL_EVENT_WINDOW_FOCUS_LOST            :
            //case SDL_EVENT_WINDOW_HIT_TEST              :
            //case SDL_EVENT_WINDOW_ICCPROF_CHANGED       :
            //case SDL_EVENT_WINDOW_DISPLAY_CHANGED       :
            //case SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED :
            //case SDL_EVENT_WINDOW_SAFE_AREA_CHANGED     :
            //case SDL_EVENT_WINDOW_OCCLUDED              :
            //case SDL_EVENT_WINDOW_ENTER_FULLSCREEN      :
            //case SDL_EVENT_WINDOW_LEAVE_FULLSCREEN      :
            //case SDL_EVENT_WINDOW_DESTROYED             :
            //case SDL_EVENT_WINDOW_HDR_STATE_CHANGED     :
            default                                     : 
        }
    }

    void
    INIT () {
        import vf.sdl.init_sdl : init_sdl;
        init_sdl ();
    }

    void
    SDL_EVENT_QUIT (SDL_QuitEvent* evt) {
        o.quit = true;
    }   

    void
    sdl_event_mouse_button_down (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt) {
            // Page with window
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;
            
            foreach (page; pages) {
                if (page.window._sdl_window == _sdl_window) {
                    page.sdl_event_mouse_button_down (evt);
                }
            }        
        }
    }    

    void
    sdl_event_mouse_button_up (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt) {
            // Page with window
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;
            
            foreach (page; pages) {
                if (page.window._sdl_window == _sdl_window) {
                    page.sdl_event_mouse_button_up (evt);
                }
            }        
        }
    }    

    void
    sdl_event_mouse_wheel (SDL_MouseWheelEvent* evt) {
        with (o)
        with (evt) {
            // Page with window
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;
            
            foreach (page; pages) {
                if (page.window._sdl_window == _sdl_window) {
                    page.sdl_event_mouse_wheel (evt);
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

