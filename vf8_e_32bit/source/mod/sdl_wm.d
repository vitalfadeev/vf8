module mod.sdl_wm;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.sdl.exceptions   : SDLException;
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

    void
    _shown (uint windowID) {
        writeln ("SHOWN");
        auto _sdl_window = SDL_GetWindowFromID (windowID);
        if (!_sdl_window) return;

        s ~= _sdl_window;
    }

    void
    _exposed (uint windowID) {
        writeln ("EXPOSED");
        _send_draw (windowID);
    }

    void
    _send_draw (uint windowID) {
        writeln ("SEND DRAW");
        with (o) {
            // Page with window
            foreach (page; o.pages) {
                auto _sdl_window = SDL_GetWindowFromID (windowID);
                if (!_sdl_window) return;
                writeln ("SEND DRAW 2");

                if (page.window == _sdl_window) {
                    Renderer renderer;
                    renderer.draw_start (_sdl_window);
                    page.draw (&renderer);  // to Page
                    renderer.draw_end (_sdl_window);
                }
            }        
        }
    }

    void
    _close (uint windowID) {
        auto _sdl_window = SDL_GetWindowFromID (windowID);
        if (!_sdl_window) return;
        SDL_DestroyWindow (_sdl_window);

        import std.algorithm : countUntil, remove;
        auto _i = countUntil!"a == b" (s, _sdl_window);
        if (_i != -1) s = s.remove (_i);

        _quit_on_last_window ();
    }

    void
    _quit_on_last_window () {
        if (s.length == 0) o.quit = true;
    }

    static
    SDL_Window*
    new_window (int w=WINDOW_DEFAULT_W, int h=WINDOW_DEFAULT_H) {
        // Window
        auto window = 
            SDL_CreateWindow (
                __FILE_FULL_PATH__, // "SDL2 Window",
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                w, h,
                SDL_WINDOW_RESIZABLE
                // | SDL_WINDOW_VULKAN
                // | SDL_WINDOW_ALLOW_HIGHDPI
            );

        if (!window)
            throw new SDLException ("Failed to create window");

        // Update
        SDL_UpdateWindowSurface (window);

        return window;
    }        
}

void
log_event (Event* evt) {
    import std.stdio : writefln;
    import vf.sdl.importc_sdl;

    with (SDL_EventType)
    if (evt.sdl.type == SDL_MOUSEMOTION)
        {}
    else
    if (evt.sdl.type == SDL_MOUSEWHEEL)
        writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, cast (SDL_MouseWheelDirection) evt.sdl.wheel.direction);
    else
    if (evt.sdl.type == SDL_WINDOWEVENT)
        writefln ("%s %d %s ", cast (SDL_EventType)evt.sdl.type, evt.sdl.window.windowID, cast (SDL_WindowEventID) evt.sdl.window.event);
    else
    if (evt.sdl.type == SDL_KEYDOWN)
        writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, evt.sdl.key.keysym.scancode);
    else
    if (evt.sdl.type == SDL_KEYUP)
        writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, evt.sdl.key.keysym.scancode);
    else
    if (evt.sdl.type < SDL_USEREVENT)
        writefln ("%s", cast (SDL_EventType) evt.sdl.type);    
    else
        writefln ("%s", evt.type);
}

