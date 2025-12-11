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


extern(C) 
void 
main () {
    tvg_engine_init(4);
        
    O o;
    o.ego = &_panel_ego;
    o.open ();
    o.go (&o,null,null,0);
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

void
_panel_ego (void* o, void* e, void* evt, REG d) {
    static Panel_e panel_e;
    panel_e.go (o,&panel_e,evt,d);
}
struct
Panel_e {
    GO go = &_go;

    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        auto _evt = cast (Event*) evt;
        REG   typ = d;
        REG   key;
        switch (typ) {
            case SDL_QUIT:
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

        go_base (o,e,evt,d);
    }
}

void
_draw_text (void* o, void* e, void* evt, REG d) {
    string text = "abc";

    with (cast(O*)o) {
    }
}


//
alias
go_stacked_this = GO_map!(
    SDL_KEYDOWN, SDLK_ESCAPE,       _go_esc,
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
        (cast(Main_E*)e).go = &go_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL released\n");
        (cast(Main_E*)e).go = &go_base;
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
