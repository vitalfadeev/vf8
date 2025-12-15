import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.map          : GO_map;
import vf.input        : Event;
import importc;

import mod.quit   : mod_quit_go = go,go_quit;
import mod.player : mod_player_go = go;
import mod.print  : mod_print_go = go,go_printf;
import mod.send   : mod_send_go = go,go_send;

enum       EVT_APP         = 0x0100;
enum       APP_CODE_QUIT   = 0x0001;
enum ulong EVT_APP_QUIT    = (APP_CODE_QUIT << 16) | EVT_APP;
enum       EVT_UI          = 0x0200;
enum ulong UI_POINTER_IN   = (2             << 16) | EVT_UI;
enum ulong UI_POINTER_OVER = (3             << 16) | EVT_UI;
enum ulong UI_POINTER_OUT  = (4             << 16) | EVT_UI;
enum ulong CLICKED         = (5             << 16) | EVT_UI;
enum ulong OPEN            = (6             << 16) | EVT_UI;
enum ulong DRAW            = (7             << 16) | EVT_UI;
enum ulong PLAY_1          = (8             << 16) | EVT_UI;
enum ulong PLAY_2          = (9             << 16) | EVT_UI;
enum ulong PLAY_3          = (10            << 16) | EVT_UI;


extern(C)
void 
main () {
    tvg_engine_init(4);
        
    O o;
    o.open ();

    // direct_send
    Event event;
    event.type           = SDL_USEREVENT;
    event.user.code      = OPEN;
    event.user.data1     = null;
    event.user.data2     = null;
    event.user.timestamp = SDL_GetTicks ();
    _app_ego (&o,&_app_ego,&event,SDL_USEREVENT);

    // event loop
    o.go (&o,&_app_ego,null,0);
}

//void 
//Event_map (Triads...) (void* o, void* e, void* evt, REG d) {
//    import std.meta : AliasSeq;

//    static if (Triads.length == 0)
//    {
//        // Базовый случай: пустой набор
//        enum result = AliasSeq!();
//    }
//    else static if (Triads.length >= 3)
//    {
//        alias Typ   = Triads[0];
//        alias Key   = Triads[1];
//        alias Value = Triads[2];

//        // Рекурсивно обрабатываем оставшиеся пары
//        enum rest   = GO_map_array_init!(Triads[3 .. $]).result;
//        enum result = AliasSeq!(Map_rec (Typ,Key,&Value), rest);

//        auto _evt = cast (Event*) evt;
//        REG   typ = _evt.type;
//        REG   key;

//        switch (typ) {
//            case SDL_WINDOWEVENT : key = _evt.window.event; break;
//            case SDL_USEREVENT   : key = _evt.user.code; break;
//            default              : key = 0;
//        }

//        switch (typ) {
//            case Typ: Value (o,e,evt,d); break;
//            case Typ: 
//                switch (key) {
//                    case Key: Value (o,e,evt,d); break;
//                    default:
//                }
//                break;
//            default:
//        }
//    }
//    else
//    {
//        static assert(0, "Количество элементов в AliasSeq должно быть 3");
//    }

//    auto _evt = cast (Event*) evt;
//    REG   typ = _evt.type;
//    REG   key;
//    with (cast(O*)o)
//    with (cast(Uni_e*)e) {
//        switch (typ) {
//            case SDL_QUIT:
//                _go_quit (o,e,evt,d);
//                break;
//            case SDL_MOUSEBUTTONDOWN:
//                // ...
//                break;
//            case SDL_WINDOWEVENT:
//                switch (_evt.window.event) {
//                    case SDL_WINDOWEVENT_EXPOSED: (cast(O*)o).video.draw (o,&uni_e,evt,d,&uni_e.draw); break; // event.window.windowID
//                    case SDL_WINDOWEVENT_CLOSE: _go_quit (o,e,evt,d); break;
//                    default:
//                }
//                break;
//            case SDL_USEREVENT:
//                if (_evt.user.code == OPEN) {
//                    printf ("on OPEN\n");
//                    uni_e.open ();
//                    uni_e.load_ui ();
//                    break;
//                }
//                if (_evt.user.code == PLAY_1) {
//                    printf ("on PLAY_1\n");
//                    _go_play_1 (o,e,evt,d);
//                    // App.go (o,e,evt,d);
//                    break;
//                }
//                if (_evt.user.code == PLAY_2) {
//                    printf ("on PLAY_2\n");
//                    _go_play_2 (o,e,evt,d);
//                    break;
//                }
//                if (_evt.user.code == PLAY_3) {
//                    printf ("on PLAY_3\n");
//                    _go_play_3 (o,e,evt,d);
//                    break;
//                }
//                break;
//            default:
//        }
//    }
//}

void
_app_ego (void* o, void* e, void* evt, REG d) {
    //Event_map!(
    //    SDL_QUIT,        null,   { _go_quit (o,e,evt,d); },
    //    SDL_WINDOWEVENT, SDL_WINDOWEVENT_EXPOSED, { (cast(O*)o).video.draw (o,&uni_e,evt,d,&uni_e.draw); },
    //    SDL_WINDOWEVENT, SDL_WINDOWEVENT_CLOSE,   { _go_quit (o,e,evt,d); },
    //    SDL_USEREVENT,   OPEN,   { printf ("on OPEN\n"); uni_e.open (); uni_e.load_ui (); },
    //    SDL_USEREVENT,   PLAY_1, { printf ("on PLAY_1\n"); _go_play_1 (o,e,evt,d); },
    //    SDL_USEREVENT,   PLAY_2, { printf ("on PLAY_2\n"); _go_play_2 (o,e,evt,d); },
    //    SDL_USEREVENT,   PLAY_3, { printf ("on PLAY_3\n"); _go_play_3 (o,e,evt,d); },
    //) (o,e,evt,d);

    static Uni_e uni_e;
    auto _evt = cast (Event*) evt;
    REG   typ = _evt.type;
    REG   key;
    with (cast(O*)o)
    with (cast(Uni_e*)e) {
        switch (typ) {
            //case SDL_QUIT:
            //    _go_quit (o,e,evt,d);
            //    break;
            case SDL_MOUSEBUTTONDOWN:
                // ...
                break;
            case SDL_WINDOWEVENT:
                switch (_evt.window.event) {
                    case SDL_WINDOWEVENT_EXPOSED: 
                        video.draw (o,&uni_e,evt,d,&uni_e.draw); 
                        break;
                    case SDL_WINDOWEVENT_CLOSE: 
                        go_quit!"Quit\n" (o,e,evt,d); 
                        break;
                    default:
                }
                break;
            case SDL_USEREVENT:
                switch (_evt.user.code) {
                    case OPEN: 
                        printf ("on OPEN\n");
                        uni_e.open ();
                        uni_e.load_ui ();
                        break;
                    //case PLAY_1: 
                    //    printf ("on PLAY_1\n");
                    //    _go_play_1 (o,e,evt,d);
                    //    break;
                    //case PLAY_2: 
                    //    printf ("on PLAY_2\n");
                    //    _go_play_2 (o,e,evt,d);
                    //    break;
                    //case PLAY_3: 
                    //    printf ("on PLAY_3\n");
                    //    _go_play_3 (o,e,evt,d);
                    //    break;
                    default:
                }
                break;
            default:
        }
    }
    mod_quit_go   (o,&uni_e,evt,d);
    mod_player_go (o,&uni_e,evt,d);
    uni_e.go (o,&uni_e,evt,d);
    go_base (o,&uni_e,evt,d);
}
struct
Uni_e {
    GO     go = &_go;
    float  x,y,w,h;
    Uni_e* l;
    Uni_e* r;
    Uni_e* cl;
    Uni_e* cr;
    Uni_e* parent;
    int    on_click_send_evt_code;  // PLAY_1
    ubyte  bg_r;
    ubyte  bg_g;
    ubyte  bg_b;
    ubyte  bg_a;

    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        // mouse btn down
        //  hit test
        //   send CLICKED
        // CLICKED
        //  send PLAY_1
        auto _evt = cast (Event*) evt;
        REG   typ = _evt.type;
        REG   key;
        with (cast(O*)o)
        with (cast(Uni_e*)e) {
            switch (typ) {
                case SDL_MOUSEBUTTONDOWN:
                    auto mx = _evt.button.x;
                    auto my = _evt.button.y;
                    if (hit_test (mx,my)) {
                        // each childs
                        //   true
                        //     child
                        //   false
                        //     this
                        printf ("send CLICKED\n");
                        direct_send (o,e,evt,d,CLICKED);
                        for (auto _e = cl; _e != null; _e = _e.r) {
                            _e.go (o,_e,evt,d);
                        }
                    }
                    break;
                case SDL_USEREVENT:
                    if (_evt.user.code == CLICKED) {
                        printf ("on CLICKED\n");
                        if (on_click_send_evt_code)
                            send (o,e,evt, on_click_send_evt_code);
                        break;
                    }
                    if (_evt.user.code == DRAW) {
                        draw (o,e,evt,cast (REG) _evt.user.data1);
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

    static
    void
    draw (void* o, void* e, void* evt, REG d) {
        with (cast(Uni_e*)e) {
            Tvg_Canvas canvas = cast (Tvg_Canvas) d;
            Tvg_Paint shape = tvg_shape_new ();
            //tvg_shape_append_rect (shape, x, y, w, h, 0.0f, 0.0f, true);
            tvg_shape_append_rect (shape, x, y, w, h, 0.0f, 0.0f, true);
            tvg_shape_set_fill_color (shape, bg_r, bg_g, bg_b, bg_a);

            //Push the shape into the canvas
            tvg_canvas_push (canvas, shape);
        }

        //childs
        with (cast(Uni_e*)e) {
            for (auto _e = cl; _e != null; _e = _e.r) {
                _e.draw (o,_e,evt,d);
            }
        }
    }

    void
    direct_send (void* o, void* e, void* evt, REG d, int code) {
        Event event;
        event.type           = SDL_USEREVENT;
        event.user.code      = code;
        event.user.data1     = null;
        event.user.data2     = null;
        event.user.timestamp = SDL_GetTicks ();
        go (o,e,&event,SDL_USEREVENT);
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
        x = 10;
        y = 10;
        w = 300;
        h = 100;

        // 1
        auto c1 = new Uni_e ();
        with (c1) {
            x = 10;
            y = 10;
            w = 90;
            h = 100;
            bg_r = 255; bg_g = 255; bg_b = 255; bg_a = 255;
            on_click_send_evt_code = PLAY_1;
        }
        this.add_child (c1);

        // 2
        auto c2 = new Uni_e ();
        with (c2) {
            x = 110;
            y = 10;
            w = 90;
            h = 100;
            bg_r = 255; bg_g = 255; bg_b = 255; bg_a = 255;
            on_click_send_evt_code = PLAY_2;
        }
        this.add_child (c2);

        // 3
        auto c3 = new Uni_e ();
        with (c3) {
            x = 210;
            y = 10;
            w = 90;
            h = 100;
            bg_r = 255; bg_g = 255; bg_b = 255; bg_a = 255;
            on_click_send_evt_code = PLAY_3;
        }
        this.add_child (c3);
    }

    void
    add_child (Uni_e* c) {
        auto t = &this;
        auto tr = t.cr;
        if (tr is null) {
            t.cr = c;
            t.cl = c;
        }
        else {
            c.l = tr;
            tr.r = c;
            t.cr = c;
        }
        c.parent = t;
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
        REG   typ = _evt.type;
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
    SDL_KEYDOWN, SDLK_ESCAPE, go_send!EVT_APP_QUIT,
);

alias 
go_base = GO_map!(
    SDL_KEYDOWN, SDLK_ESCAPE, go_quit!"Quit\n",
    SDL_KEYDOWN, SDLK_LCTRL,  _go_ctrl_pressed,
    SDL_KEYDOWN, SDLK_a,      go_printf!"A! OK!\n",
    SDL_KEYDOWN, SDLK_q,      go_send!PLAY_1,
    SDL_KEYDOWN, SDLK_w,      go_send!PLAY_2,
    SDL_KEYDOWN, SDLK_e,      go_send!PLAY_3,
);

alias 
go_ctrl_pressed = GO_map!(
    SDL_KEYUP,   SDLK_LCTRL, _go_ctrl_released,
    SDL_KEYDOWN, SDLK_a,     go_printf!"CTRL+A\n",
);


//
//alias 
//_go_quit = go_quit!"QUIT\n";

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


//
void
GO_ui (void* o, void* e, void* evt, REG d) {
    auto _evt = cast (Event*) evt;
    REG   typ = _evt.type;
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
        REG   typ = _evt.type;
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
        REG   typ = _evt.type;
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
                    case SDL_WINDOWEVENT_EXPOSED: (cast(O*)o).video.draw (content_cb); break; // event.window.windowID
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
