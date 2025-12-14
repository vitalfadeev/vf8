import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.map          : GO_map;
import vf.input        : Event;
import importc;

enum       EVT_APP         = 0x0100;
enum       APP_CODE_QUIT   = 0x0001;
enum ulong EVT_APP_QUIT    = (APP_CODE_QUIT << 16) | EVT_APP;
enum       EVT_UI          = 0x0200;
enum ulong UI_POINTER_IN   = (2             << 16) | EVT_UI;
enum ulong UI_POINTER_OVER = (3             << 16) | EVT_UI;
enum ulong UI_POINTER_OUT  = (4             << 16) | EVT_UI;
enum ulong CLICKED         = (5             << 16) | EVT_UI;
enum ulong DRAW            = (6             << 16) | EVT_UI;
enum ulong PLAY_1          = (7             << 16) | EVT_UI;


extern(C)
void 
main () {
    tvg_engine_init(4);
        
    O o;
    o.open ();
    o.go (&o,&_uni_ego,null,0);
}

void
_ego (void* o, void* e, void* evt, REG d) {
    static Main_E main_e;
    main_e.go (o,&main_e,evt,d);
}

struct
Main_E {
    GO go = &go_base;
}

version (_NEVER_)
void
_panel_ego (void* o, void* e, void* evt, REG d) {
    static Panel_e panel_e;
    panel_e.open ();
    panel_e.go (o,&panel_e,evt,d);
    go_base (o,&panel_e,evt,d);
}
version (_NEVER_)
struct
Panel_e {
    GO go = &_go;
    SDL_Window* window;
    bool        opened;
    Text_e      text;

    void
    open () {
        if (opened) return;
        opened = true;
        // get screen size
        // create window
        SDL_DisplayMode mode;
        SDL_GetDesktopDisplayMode (0, &mode);
        //SDL_GetCurrentDisplayMode (0, &mode);

        window = 
            SDL_CreateWindow (
                __FILE_FULL_PATH__, // "SDL2 Window",
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                0,
                mode.w, 64,
                SDL_WINDOW_BORDERLESS
                | SDL_WINDOW_VULKAN
                | SDL_WINDOW_ALLOW_HIGHDPI
            );

        import vf.video : SDLException;
        if (!window)
            throw new SDLException ("Failed to create window");

        // Update
        SDL_UpdateWindowSurface (window);
    }

    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        auto _evt = cast (Event*) evt;
        REG   typ = d;
        REG   key;

        //Map!(
        //    SDL_QUIT,           null,                           { _go_quit (o,e,evt,d); },
        //    SDL_MOUSEBUTTONDOWN,null,                           {},
        //    SDL_KEYDOWN,        SDLK_a,                         {},
        //    SDL_KEYDOWN,        SDLK_ESCAPE,                    {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_EXPOSED,        { (cast(O*)o).video.draw (); },
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_SHOWN,          {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_HIDDEN,         {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_MOVED,          {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_RESIZED,        {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_SIZE_CHANGED,   {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_MINIMIZED,      {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_MAXIMIZED,      {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_RESTORED,       {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_ENTER,          {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_LEAVE,          {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_FOCUS_GAINED,   {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_FOCUS_LOST,     {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_CLOSE,          {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_TAKE_FOCUS,     {},
        //    SDL_WINDOWEVENT,    SDL_WINDOWEVENT_HIT_TEST,       {},
        //) (o,e,evt,d);

        switch (typ) {
            case SDL_QUIT:
                _go_quit (o,e,evt,d); 
                break;
            case SDL_MOUSEBUTTONDOWN:
                // ...
                break;
            case SDL_KEYDOWN:
                if (_evt.key.keysym.sym == SDLK_ESCAPE)
                    break;
                break;
            case SDL_WINDOWEVENT:
                switch (_evt.window.event) {
                    case SDL_WINDOWEVENT_EXPOSED: (cast(O*)o).video.draw (); break; // event.window.windowID
                    case SDL_WINDOWEVENT_SHOWN: break;        // event.window.windowID
                    case SDL_WINDOWEVENT_HIDDEN: break;       // event.window.windowID
                    case SDL_WINDOWEVENT_MOVED: break;        // event.window.windowID event.window.data1 event.window.data2 (x y)
                    case SDL_WINDOWEVENT_RESIZED: break;      // event.window.windowID event.window.data1 event.window.data2 (width height)
                    case SDL_WINDOWEVENT_SIZE_CHANGED: break; // event.window.windowID event.window.data1 event.window.data2 (width height)
                    case SDL_WINDOWEVENT_MINIMIZED: break;    // event.window.windowID
                    case SDL_WINDOWEVENT_MAXIMIZED: break;    // event.window.windowID
                    case SDL_WINDOWEVENT_RESTORED: break;     // event.window.windowID
                    case SDL_WINDOWEVENT_ENTER: break;        // event.window.windowID
                    case SDL_WINDOWEVENT_LEAVE: break;        // event.window.windowID
                    case SDL_WINDOWEVENT_FOCUS_GAINED: break; // event.window.windowID
                    case SDL_WINDOWEVENT_FOCUS_LOST: break;   // event.window.windowID
                    case SDL_WINDOWEVENT_CLOSE: break;        // event.window.windowID
                    case SDL_WINDOWEVENT_TAKE_FOCUS: break;   // event.window.windowID
                    case SDL_WINDOWEVENT_HIT_TEST: break;     // event.window.windowID
                    default:
                        SDL_Log ("Window %d got unknown event %d",
                            _evt.window.windowID, _evt.window.event);
                }
                break;
            default:
                //writeln (ev);
        }
    }
}

version (_NEVER_)
struct
Text_e {
    GO   go   = &_go;

    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        //
    }

    string font_file    = "resources/font/Arial.ttf";
    string font_name    = "Arial";
    float  font_size    = 25.0f;
    ubyte  font_color_r = 200;
    ubyte  font_color_g = 200;
    ubyte  font_color_b = 200;
    string text         = "ThorVG is the best";
    float  x            = 50.0f;
    float  y            = 50.0f;

    static
    void
    _draw (void* o, void* e, void* evt, REG d) {
        with (cast(O*)o) 
        with (cast(Text_e*)e)  
        {
            auto canvas = cast (Tvg_Canvas) d;

            //
            if (tvg_font_load (font_file.ptr) != TVG_RESULT_SUCCESS) {
                printf ("Problem with loading the font from the file. Did you enable TTF Loader?\n");
            }

            Tvg_Paint _text = tvg_text_new ();
            tvg_text_set_font   (_text, font_name.ptr);
            tvg_text_set_size   (_text, font_size);
            tvg_text_set_color  (_text, font_color_r, font_color_g, font_color_b);
            tvg_text_set_text   (_text, text.ptr);
            tvg_paint_translate (_text, x, y);
            tvg_canvas_push (canvas, _text);
        }
    }
}

//struct
//Container {
//    GO      go = &_go;
//    Content content;

//    struct
//    Content {
//        void* a;
//        void* z;

//        struct
//        Rec {
//            void* data;
//            Rec*  prev;
//            Rec*  next;
//        }
//    }

//    static
//    void
//    _go (void* o, void* e, void* evt, REG d) {
//        //
//    }

//    static
//    void
//    _content (void* o, void* e, void* evt, REG d) {
//        with (cast(O*)o) 
//        with (cast(Container*)e)
//        {
//            foreach (_e; es) {
//                _e.go (o,_e,evt,d);
//            }
//        }
//    }
//}

void
_uni_ego (void* o, void* e, void* evt, REG d) {
    static Uni_e uni_e;
    uni_e.open ();
    uni_e.load_ui ();
    uni_e.go (o,&uni_e,evt,d);
    go_base (o,&uni_e,evt,d);
}
struct
Uni_e {
    GO     go = &_go;
    int    x,y,w,h;
    Uni_e* l;
    Uni_e* r;
    Uni_e* cl;
    Uni_e* cr;
    int    on_click_send_evt_code;  // PLAY_1
    int    bg;

    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        // mouse btn down
        //  hit test
        //   send CLICKED
        // CLICKED
        //  send PLAY_1
        auto _evt = cast (Event*) evt;
        REG   typ = d;
        REG   key;
        with (cast(O*)o)
        with (cast(Uni_e*)e) {
            switch (typ) {
                case SDL_MOUSEBUTTONDOWN:
                    auto mx = _evt.button.x;
                    auto my = _evt.button.y;
                    if (hit_test (mx,my)) {
                        send (o,e,evt,CLICKED);
                    }
                    break;
                case SDL_USEREVENT:
                    if (_evt.user.code == CLICKED) {
                        send (o,e,evt,PLAY_1);
                        break;
                    }
                    if (_evt.user.code == DRAW) {
                        draw (cast (Tvg_Canvas*) _evt.user.data1);
                        break;
                    }
                    break;
                default:
            }
        }
    }

    bool
    hit_test (int mx, int my) {
        if (x <= mx && y <= my)
        if ((x+w) > mx && (y+h) > my)
            return true;

        return false;
    }

    void
    draw (Tvg_Canvas* canvas) {
        //
    }

    void
    send (void* o, void* e, void* evt, int code) {
        with (cast(O*)o) {
            local_input.put_reg (code,e);
        }
    }

    bool opened;
    SDL_Window* window;
    void
    open () {
        if (opened) return;
        opened = true;
        // get screen size
        // create window
        SDL_DisplayMode mode;
        SDL_GetDesktopDisplayMode (0, &mode);
        //SDL_GetCurrentDisplayMode (0, &mode);

        window = 
            SDL_CreateWindow (
                __FILE_FULL_PATH__, // "SDL2 Window",
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                0,
                mode.w, 64,
                SDL_WINDOW_BORDERLESS
                | SDL_WINDOW_VULKAN
                | SDL_WINDOW_ALLOW_HIGHDPI
            );

        import vf.video : SDLException;
        if (!window)
            throw new SDLException ("Failed to create window");

        // Update
        SDL_UpdateWindowSurface (window);
    }

    bool loaded;
    void
    load_ui () {
        if (loaded) return;
        loaded = true;

        // x,y,w,h, bg
        // add childs 1
        //   x,y,w,h, bg, on_click_send_evt_code
        // add childs 2
        //   x,y,w,h, bg, on_click_send_evt_code
        // add childs 3
        //   x,y,w,h, bg, on_click_send_evt_code
    }
}

struct
App {
    GO go = &_go;

    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        // SDL_USEREVENT,   PLAY_1,                  { audio.play (1); },
        // SDL_QUIT,        null,                    { _go_quit (o,e,evt,d); },
        // SDL_WINDOWEVENT, SDL_WINDOWEVENT_EXPOSED, { (cast(O*)o).video.draw (); },
        auto _evt = cast (Event*) evt;
        REG   typ = d;
        REG   key;
        with (cast(O*)o)
        with (cast(App*)e) {
            switch (typ) {
                case SDL_USEREVENT:
                    if (_evt.user.code == PLAY_1) {
                        // audio.play (1);
                    }
                    break;
                default:
            }
        }
    }
}

// Container
//   Button
//   Clock
//   Indicators

//
alias
go_stacked_this = GO_map!(
    SDL_KEYDOWN, SDLK_ESCAPE, _go_esc,
);

alias 
go_base = GO_map!(
    SDL_KEYDOWN, SDLK_ESCAPE, _go_quit,
    SDL_KEYDOWN, SDLK_LCTRL,  _go_ctrl_pressed,
    SDL_KEYDOWN, SDLK_a,      _go_a_pressed,
    SDL_KEYDOWN, SDLK_q,      _go_play_1,
    SDL_KEYDOWN, SDLK_w,      _go_play_2,
    SDL_KEYDOWN, SDLK_e,      _go_play_3,
);

alias 
go_ctrl_pressed = GO_map!(
    SDL_KEYUP,   SDLK_LCTRL, _go_ctrl_released,
    SDL_KEYDOWN, SDLK_a,     _go_ctrl_a,
);


//
alias 
_go_quit = GO_quit!"QUIT\n";

alias
_go_esc = GO_local_event_new!(EVT_APP_QUIT);

void
_go_ctrl_pressed (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL pressed\n");
        (cast(Uni_e*)e).go = &go_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL released\n");
        (cast(Uni_e*)e).go = &go_base;
    }
}

alias
_go_ctrl_a = GO_printf!"CTRL+A\n";

alias
_go_a_pressed = GO_printf!"A! OK!\n";

alias
_go_play_1 = GO_play!(1);

alias
_go_play_2 = GO_play!(2);

alias
_go_play_3 = GO_play!(3);

//
void
GO_quit (alias TEXT) (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf (TEXT);
        go = null;
    }
}

void
GO_printf (alias TEXT) (void* o, void* e, void* evt, REG d) {
    printf (TEXT);
}

void
GO_local_event_new (REG EVT) (void* o, void* e, void* evt, REG d) {
    printf ("  put Event: 0x%X\n", EVT);
    with (cast(O*)o) {
        local_input.put_reg (EVT);
    }
}

void
GO_play (int resource_id) (void* o, void* e, void* evt, REG d) {
    printf ("Play %d\n", resource_id);
    with (cast(O*)o) {
        audio.play_wav (resource_id);
    }
}

//
void
GO_ui (void* o, void* e, void* evt, REG d) {
    auto _evt = cast (Event*) evt;
    REG   typ = d;
    REG   key;
    with (cast(O*)o) {
        if (typ == SDL_MOUSEMOTION) {
            //go_ui_each (o,e,evt,d);
        }
    }
}

struct
UI_element {
    GO     go = &_go;
    UI*    l;
    UI*    r;
    UI*    v;
    ubyte  flags;
    Style* styles;  // base, hover
    Style  style_calculated;

    alias UI = UI_element;

    enum 
    Flags {
        mouse_over = 0b00000001,
    }

    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        auto _evt = cast (Event*) evt;
        REG   typ = d;
        REG   key;
        with (cast(O*)o) {
            switch (typ) {
                case SDL_MOUSEMOTION:
                    with (cast(UI_element*)e)
                    if ((cast(UI_element*)e).hit_test (o,e,evt,d)) {
                        if (flags & Flags.mouse_over) {
                            //local_input.put_reg (UI_POINTER_OVER,e);
                        } 
                        else {
                            flags |= Flags.mouse_over;
                            //local_input.put_reg (UI_POINTER_IN,e);
                        }
                    }
                    else {
                        if (flags & Flags.mouse_over) {
                            flags &= !Flags.mouse_over;
                            //local_input.put_reg (UI_POINTER_OUT,e);
                        }                     
                    }
                    break;

                case SDL_USEREVENT:
                    if (_evt.user.code == UI_POINTER_IN) {
                        // change style
                        //   back color
                    }

                    if (_evt.user.code == UI_POINTER_OVER) {
                        // change style
                        //   back color
                    }

                    if (_evt.user.code == UI_POINTER_OUT) {
                        // change style
                        //   back color
                    }
                    break;
                default:
                }
        }
    }

    static
    bool
    hit_test (void* o, void* e, void* evt, REG d) {
        return false;
    }
}

struct
Style {
    Color  bg;
    Color  fg;
    Style* next;
}

alias 
Color = uint;
