module mod.sdl_wm;

version (SDL):
import std.algorithm       : countUntil, remove;
import vf.std.xywh;
import vf.gui.page         : Page;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.sdl.exceptions   : SDLException;
import vf.sdl.log_event    : log_event;
import app                 : o;
import std.stdio           : writeln;

enum WINDOW_DEFAULT_W = 1024;
enum WINDOW_DEFAULT_H = 480;


struct
Sdl_wm {
    static SDL_Window*[] s;

    void
    INIT () {
        //
    }

    void
    SDL_EVENT_WINDOW_SHOWN (SDL_WindowEvent* evt) {
        _shown (evt.windowID);
    }

    void
    SDL_EVENT_WINDOW_EXPOSED (SDL_WindowEvent* evt) {
        _exposed (evt.windowID);
    }

    void
    SDL_EVENT_WINDOW_CLOSE_REQUESTED (SDL_WindowEvent* evt) {
        _close (evt.windowID);
    }

    void
    SDL_EVENT_KEY_DOWN (SDL_KeyboardEvent* evt) {
        with (o)
        with (evt)
        switch (scancode) {
            case SDL_SCANCODE_ESCAPE : _close (windowID); break;
            case SDL_SCANCODE_Q      : _close (windowID); break;
            default                  :
        }
    }

    void
    _shown (uint windowID) {
        auto _sdl_window = SDL_GetWindowFromID (windowID);
        if (!_sdl_window) return;
    }

    void
    _exposed (uint windowID) {
        _send_draw (windowID);
    }

    void
    _send_draw (uint windowID) {
        with (o) {
            // Page with window
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;
            
            foreach (page; pages) {
                if (page.window._sdl_window == _sdl_window) {
                    page.draw ();
                }
            }        
        }
    }

    void
    _close (uint windowID) {
        with (o) {
            auto _sdl_window = SDL_GetWindowFromID (windowID);
            if (!_sdl_window) return;

            SDL_DestroyWindow (_sdl_window);

            _remove (_sdl_window);
            _unregister_page (_sdl_window);
            _quit_on_last_window ();
        }
    }

    void
    _remove (SDL_Window* _sdl_window) {
        auto _i = s.countUntil (_sdl_window);
        if (_i != -1) s = s.remove (_i);        
    }

    void
    _unregister_page (SDL_Window* _sdl_window) {
        with (o)
        foreach (i,page; pages) {
            if (page.window._sdl_window == _sdl_window) {
                pages = pages.remove (i);
                page.destroy ();
                break;
            }
        }                
    }

    void
    _quit_on_last_window () {
        if (s.length == 0) o.quit = true;
    }

    SDL_Window*
    new_window (int x, int y, int w, int h, uint flags) {
        // Window
        auto _sdl_window = 
            SDL_CreateWindow (
                __FILE_FULL_PATH__, // "SDL2 Window",
                w, h,
                flags
            );

        if (!_sdl_window)
            throw new SDLException ("Failed to create window");

        SDL_SetWindowPosition (_sdl_window,x,y);

        // Update
        SDL_UpdateWindowSurface (_sdl_window);

        s ~= _sdl_window;

        return _sdl_window;
    }    
}
