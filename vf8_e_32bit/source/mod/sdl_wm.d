module mod.sdl_wm;

version (SDL):
import std.algorithm : countUntil, remove;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.sdl.exceptions   : SDLException;
import vf.sdl.log_event : log_event;
import app : o;
import std.stdio : writeln;

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
    SDL_WINDOWEVENT (SDL_WindowEvent* evt) {
        with (o)
        with (evt)
        switch (event) with (SDL_WindowEventID) {
            case SDL_WINDOWEVENT_SHOWN   : _shown   (windowID); break;
            case SDL_WINDOWEVENT_EXPOSED : _exposed (windowID); break;
            case SDL_WINDOWEVENT_CLOSE   : _close   (windowID); break;
            default                      :
        }
    }

    void
    SDL_KEYDOWN (SDL_KeyboardEvent* evt) {
        // SDL_KEYDOWN
        // SDL_KEYUP
        with (o)
        with (evt)
        switch (keysym.scancode) {
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
            foreach (page; o.pages) {
                auto _sdl_window = SDL_GetWindowFromID (windowID);
                if (!_sdl_window) return;

                if (page.window._sdl_window == _sdl_window) {
                    page.draw ();
                }
            }        
        }
    }

    void
    _close (uint windowID) {
        auto _sdl_window = SDL_GetWindowFromID (windowID);
        if (!_sdl_window) return;

        SDL_DestroyWindow (_sdl_window);

        auto _i = s.countUntil (_sdl_window);
        if (_i != -1) s = s.remove (_i);

        _quit_on_last_window ();
    }

    void
    _quit_on_last_window () {
        if (s.length == 0) o.quit = true;
    }

    SDL_Window*
    new_window (int w, int h) {
        // Window
        auto _sdl_window = 
            SDL_CreateWindow (
                __FILE_FULL_PATH__, // "SDL2 Window",
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                w, h,
                SDL_WINDOW_RESIZABLE
                // | SDL_WINDOW_VULKAN
                // | SDL_WINDOW_ALLOW_HIGHDPI
            );

        if (!_sdl_window)
            throw new SDLException ("Failed to create window");

        // Update
        SDL_UpdateWindowSurface (_sdl_window);

        s ~= _sdl_window;

        return _sdl_window;
    }    
}
