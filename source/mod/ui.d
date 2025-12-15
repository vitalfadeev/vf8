module mod.ui;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.o_base : send;
import vf.o_base : send_d_code;
import vf.input        : Event;
import mod.quit        : go_quit;
import importc;

enum       EVT_UI          = 0x0200;
enum ulong CLICKED         = (5             << 16) | EVT_UI;
enum ulong OPEN            = (6             << 16) | EVT_UI;
enum ulong DRAW            = (7             << 16) | EVT_UI;
enum ulong PLAY_1          = (8             << 16) | EVT_UI;
enum ulong PLAY_2          = (9             << 16) | EVT_UI;
enum ulong PLAY_3          = (10            << 16) | EVT_UI;

static Uni_e uni_e;

void
go (void* o, void* e, void* evt, REG d) {
    auto _evt = cast (Event*) evt;
    REG   typ = _evt.type;

    with (cast(O*)o) {
        switch (typ) {
            case SDL_MOUSEBUTTONDOWN:
                // ...
                break;
            case SDL_WINDOWEVENT:
                switch (_evt.window.event) {
                    case SDL_WINDOWEVENT_EXPOSED: 
                        video.draw (o,e,evt,d);
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
                        open ();
                        load_ui ();
                        break;
                    default:
                }
                break;
            default:
        }
    }

    uni_e.go (o,&uni_e,evt,d);
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

    with (uni_e) {
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
        add_child (c1);

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
        add_child (c2);

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
        add_child (c3);
    }
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
                    switch (_evt.user.code) {
                        case CLICKED: 
                            printf ("on CLICKED\n");
                            if (on_click_send_evt_code)
                                send_d_code!(SDL_USEREVENT) (o,e,evt,on_click_send_evt_code);
                            break;
                        case DRAW: 
                            draw (o,e,evt,d);
                            break;
                        default:
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
            auto _evt = cast (Event*) evt;
            Tvg_Canvas canvas = cast (Tvg_Canvas) _evt.user.data1;
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
                _e.go (o,_e,evt,d);  // DRAW
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
