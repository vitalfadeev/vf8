import core.stdc.stdio : printf;
import vf.types        : GO,REG;
//import vf.key_codes    : EVT_KEY_ESC_PRESSED;
//import vf.key_codes    : EVT_APP_QUIT;
enum       EVT_APP                   = 0x0100;
enum       APP_CODE_QUIT             = 0x0001;
enum ulong EVT_APP_QUIT = (APP_CODE_QUIT     << 16) | EVT_APP;
enum       EVT_UI                    = 0x0200;
enum ulong UI_POINTER_IN             = (2     << 16) | EVT_UI;
enum ulong UI_POINTER_OVER           = (3     << 16) | EVT_UI;
enum ulong UI_POINTER_OUT            = (4     << 16) | EVT_UI;
//import vf.key_codes    : EVT_KEY_LEFTCTRL_PRESSED,EVT_KEY_LEFTCTRL_RELEASED;
//import vf.key_codes    : EVT_KEY_A_PRESSED;
//import vf.key_codes    : EVT_KEY_Q_PRESSED,EVT_KEY_W_PRESSED,EVT_KEY_E_PRESSED;
import vf.o_base       : O;
import vf.map          : GO_map;
import importc;

//import vf.key_codes    : EVT_REL_MOVED;
//import vf.key_codes    : UI_POINTER_IN;
//import vf.key_codes    : UI_POINTER_OVER;
//import vf.key_codes    : UI_POINTER_OUT;


extern(C) 
void 
main () {
    O o;
    o.ego = &_ego;
    o.open ();
    o.go (&o,null,0,0);
}

alias 
_ego = go_base;

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
_go_ctrl_pressed (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL pressed\n");
        ego = &go_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL released\n");
        ego = &go_base;
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
GO_quit (alias TEXT) (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf (TEXT);
        go = null;
    }
}

void
GO_printf (alias TEXT) (void* o, void* e, REG evt, REG d) {
    printf (TEXT);
}

void
GO_local_event_new (REG EVT) (void* o, void* e, REG evt, REG d) {
    printf ("  put Event: 0x%X\n", EVT);
    with (cast(O*)o) {
        local_input.put_reg (EVT);
    }
}

void
GO_play (int resource_id) (void* o, void* e, REG evt, REG d) {
    printf ("Play %d\n", resource_id);
    with (cast(O*)o) {
        audio.play_wav (resource_id);
    }
}

//
void
GO_ui (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        if (evt == SDL_MOUSEMOTION) {
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
    _go (void* o, void* e, REG evt, REG d) {
        with (cast(O*)o) {
            if (evt == SDL_MOUSEMOTION) {
                with (cast(UI_element*)e)
                if ((cast(UI_element*)e).hit_test (o,e,evt,d)) {
                    if (flags & Flags.mouse_over) {
                        local_input.put_reg (UI_POINTER_OVER,e);
                    } 
                    else {
                        flags |= Flags.mouse_over;
                        local_input.put_reg (UI_POINTER_IN,e);
                    }
                }
                else {
                    if (flags & Flags.mouse_over) {
                        flags &= !Flags.mouse_over;
                        local_input.put_reg (UI_POINTER_OUT,e);
                    }                     
                }
            }

            if (evt == UI_POINTER_IN) {
                // change style
                //   back color
            }

            if (evt == UI_POINTER_OVER) {
                // change style
                //   back color
            }

            if (evt == UI_POINTER_OUT) {
                // change style
                //   back color
            }
        }
    }

    static
    bool
    hit_test (void* o, void* e, REG evt, REG d) {
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


import vf.input : Event;
int
check_event (Event ev) {
    switch (ev.type) {
        case SDL_QUIT:
            return 0;
        case SDL_MOUSEBUTTONDOWN:
            // ...
            break;
        case SDL_KEYDOWN:
            if (ev.key.keysym.sym == SDLK_ESCAPE)
                return 0;
            break;
        case SDL_WINDOWEVENT:
            switch (ev.window.event) {
//                case SDL_WINDOWEVENT_EXPOSED: draw (renderer); break; // event.window.windowID
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
                        ev.window.windowID, ev.window.event);
            }
            break;
        default:
            //writeln (ev);
    }

    return 0;
}

