module vf.sdl.wm;

version (SDL):
import app                 : Event;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.sdl.window       : Window;
import vf.sdl.window       : WINDOW_DEFAULT_W, WINDOW_DEFAULT_H;

struct
Wm {
    static Window[] s;

    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case INIT            : _init (evt); break;
            default              :
        }
        switch (evt.sdl.type) with (SDL_EventType) {
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
    _do_sdl_window (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.window)
        switch (event) with (SDL_WindowEventID) {
            case SDL_WINDOWEVENT_CLOSE:
                _close_window (evt,windowID);
                break;
            case SDL_WINDOWEVENT_EXPOSED:
                _send_draw (evt, windowID);
                break;
            default:
        }
    }

    void
    _do_sdl_keydown (Event* evt) {
        // SDL_KEYDOWN
        // SDL_KEYUP
        with (evt.o)
        with (evt.sdl.key)
        switch (keysym.scancode) {
            case SDL_SCANCODE_ESCAPE : _close_window (evt,windowID); break;
            case SDL_SCANCODE_Q      : _close_window (evt,windowID); break;
            default                  :
        }
    }

    Window*
    new_window (int w=WINDOW_DEFAULT_W, int h=WINDOW_DEFAULT_H) {
        s ~= Window (w,h);
        return &s[$-1];
    }

    void
    _send_draw (Event* evt, uint windowID) {
        with (evt.o)
        with (Event.Type) {            
            Renderer renderer;
            renderer.draw_start (windowID);
            send_now (DRAW, windowID, &renderer);
            renderer.draw_end (windowID);
        }
    }

    void
    _close_window (Event* evt, uint windowID) {
        auto _sdl_window = SDL_GetWindowFromID (windowID);
        if (!_sdl_window) return;
        SDL_DestroyWindow (_sdl_window);

        import std.algorithm : countUntil, remove;
        auto _i = countUntil!"a.window == b" (s, _sdl_window);
        if (_i != -1) s = s.remove (_i);

        _quit_on_last_window (evt);
    }

    void
    _quit_on_last_window (Event* evt) {
        if (s.length == 0) evt.o.quit = true;
    }
}
