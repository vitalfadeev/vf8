module vf.sdl.wm;

version (SDL):
import app                 : Event;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.sdl.window       : Window;
import vf.sdl.window       : WINDOW_DEFAULT_W, WINDOW_DEFAULT_H;

struct
Wm (O) {
    O*              o;
    static Window[] s;

    void
    INIT () {
        //
    }

    void
    SDL_WINDOWEVENT (SDL_WindowEvent* evt) {
        with (o)
        with (evt)
        switch (event) with (SDL_WindowEventID) {
            case SDL_WINDOWEVENT_CLOSE:
                _close_window (windowID);
                break;
            case SDL_WINDOWEVENT_EXPOSED:
                _send_draw (windowID);
                break;
            default:
        }
    }

    //void
    //SDL_KEYDOWN (SDL_KeyboardEvent* evt) {
    //    // SDL_KEYDOWN
    //    // SDL_KEYUP
    //    with (o)
    //    with (evt)
    //    switch (keysym.scancode) {
    //        case SDL_SCANCODE_ESCAPE : _close_window (evt,windowID); break;
    //        case SDL_SCANCODE_Q      : _close_window (evt,windowID); break;
    //        default                  :
    //    }
    //}

    Window*
    new_window (int w=WINDOW_DEFAULT_W, int h=WINDOW_DEFAULT_H) {
        s ~= Window (w,h);
        return &s[$-1];
    }

    void
    _send_draw (uint windowID) {
        with (o) {
            Renderer renderer;
            renderer.draw_start (windowID);
            hub.DRAW (windowID, &renderer);
            renderer.draw_end (windowID);
        }
    }

    void
    _close_window (uint windowID) {
        auto _sdl_window = SDL_GetWindowFromID (windowID);
        if (!_sdl_window) return;
        SDL_DestroyWindow (_sdl_window);

        import std.algorithm : countUntil, remove;
        auto _i = countUntil!"a.window == b" (s, _sdl_window);
        if (_i != -1) s = s.remove (_i);

        _quit_on_last_window ();
    }

    void
    _quit_on_last_window () {
        if (s.length == 0) o.quit = true;
    }
}
