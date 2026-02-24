module vf.sdl.wm;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl;
import vf.sdl.window : Window;
import vf.sdl.window : WINDOW_DEFAULT_W, WINDOW_DEFAULT_H;

struct
Wm {
    Window[] s;

    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case INIT            : _init (evt); break;
            default              :
        }
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_WINDOWEVENT : _do_sdl_window  (evt); break;
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
                import std.algorithm : countUntil, remove;
                auto _sdl_window = SDL_GetWindowFromID (windowID);
                if (!_sdl_window) return;
                SDL_DestroyWindow (_sdl_window);
                auto _i = countUntil!"a.window == b" (s, _sdl_window);
                if (_i != -1) s = s.remove (_i);
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
    new_window (int w=WINDOW_DEFAULT_W, int h=WINDOW_DEFAULT_H) {
        s ~= Window (w,h);
    }
}
