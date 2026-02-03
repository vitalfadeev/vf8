import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.local_input  : Local_input;
import vf.audio        : Audio;
import vf.video        : Video;
import event;
import importc;
import std.stdio : writeln;
import attrs : Calculated;
import klass;


extern(C)
void 
main () {
    auto o = new O3 ();
    o.open ();

    //binds (o);

    o.send_now (Event.Type.OPEN);
    o.send_now (Event.Type.UPDATE);
    o.send_now (Event.Type.SET_E_PROP);
    o.send_now (Event.Type.LAYOUT);

    import e_class : dump_tree,dump_tree2;
    dump_tree (o.gui.e);

    o.go ();   // event loop
}

class
O3 : O!(Event) {
    Audio audio;
    Video video;
    Gui   gui;

    override
    void
    open () {
        SDL_Init (SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS);
        audio.open ();
        video.open ();
        super.open ();
        gui.open (this);
    }

    override
    void
    ego (Event* evt) {
        mod_quit_go     (evt);
        mod_sdl_quit_go (evt);
        mod_player_go   (evt);
        mod_key_go      (evt);
        mod_video       (evt);
        mod_ui_go       (evt);
    }

    void
    mod_quit_go (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case QUIT: 
                printf ("on QUIT\n");
                go_flag = false;
                break;
            default:
        }
    }

    void
    mod_sdl_quit_go (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case SDL:
                if (evt.sdl.sdl_event.type ==  SDL_QUIT) {
                    printf ("on SQL QUIT\n");
                    send (Event.Type.QUIT);
                }
                break;
            default:
        }
    }

    void
    mod_player_go (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case PLAY:
                printf ("on PLAY %d\n", evt.play.id);
                audio.play_wav (evt.play.id);
                break;
            default:
        }
    }

    void
    mod_video (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case SDL:
                with (evt.sdl.sdl_event)
                if (type == SDL_WINDOWEVENT)
                switch (window.event) {
                    case SDL_WINDOWEVENT_EXPOSED: 
                        //printf ("on SDL_WINDOWEVENT_EXPOSED\n");
                        video.draw_start (this,evt);
                        send_now!(Event.Type.DRAW, "draw", "canvas") (video.canvas);
                        video.draw_end   (this,evt);
                        break;
                    case SDL_WINDOWEVENT_CLOSE: 
                        send (Event.Type.QUIT);
                        break;
                    default:
                }
                break;
            case REDRAW:
                video.draw_start (this,evt);
                send_now!(Event.Type.DRAW, "draw", "canvas") (video.canvas);
                video.draw_end   (this,evt);
                break;
            default:
        }
    }

    void
    mod_ui_go (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP :
                with (evt.set_e_prop)
                foreach (e; gui.e.childs_recursive ()) {
                    foreach (k; e.klasses) e.set_e_prop (k);
                }
                break;
            case LAYOUT :
                with (evt.layout)
                foreach (e; gui.e.childs_recursive ()) {
                    if (e.has_childs) e.go_layout (evt);
                }
                break;
            case DRAW :
                with (evt.draw)
                foreach (e; gui.e.childs_recursive ()) {
                    with (e) 
                    with (Calculated!E (e)) {
                        draw_rect (canvas,xy,wh,bg,fg);
                        draw_text (canvas,xy,wh,text);
                    }
                }
                break;
            case SDL:
                with (evt.sdl.sdl_event)
                switch (type) {
                case SDL_MOUSEBUTTONDOWN: 
                    with (button)
                    switch (button) {
                    case SDL_BUTTON_LEFT : 
                        auto _mouse_over_e = gui.select (x,y);
                        if (_mouse_over_e !is null) {
                            writeln ("_mouse_over_e down");
                            with (Calculated!E (_mouse_over_e))
                            send (Event (Event_click (CLICK, x, y)));
                            mod_ui_widget_go (evt,_mouse_over_e);
                        }
                        break;
                    default:
                    }
                    break;
                case SDL_MOUSEBUTTONUP: 
                    with (button)
                    switch (button) {
                    case SDL_BUTTON_LEFT : 
                        auto _mouse_over_e = gui.select (x,y);
                        if (_mouse_over_e !is null) {
                            writeln ("_mouse_over_e up");
                            mod_ui_widget_go (evt,_mouse_over_e);
                        }
                        break;
                    default:
                    }
                    break;
                default:
                }
                break;
            case CLICK:
                writeln ("CLICK");
                with (evt.click) {
                    auto _mouse_over_e = gui.select (x,y);
                    if (_mouse_over_e !is null) {
                        _mouse_over_e._on.go (evt, _mouse_over_e);
                    }
                }
                break;
            default:
        }
    }

    void
    mod_ui_widget_go (Event* evt, E e) {
        with (e) 
        switch (e.type._etype.a) with (E.Type) {
        case BUTTON:
            with (evt.Type)
            switch (evt.type) {
            case SDL:
                with (evt.sdl.sdl_event)
                switch (type) {
                case SDL_MOUSEBUTTONDOWN: 
                    with (button)
                    switch (button) {
                    case SDL_BUTTON_LEFT: 
                        // pressed
                        //this.klasses.pressed;
                        if (e.has_klass ("pressed") is null) {
                            e.add_klass (select_klass ("pressed"));
                            send (SET_E_PROP);
                            send (REDRAW);
                        }
                        break;
                    default:
                    }
                    break;
                case SDL_MOUSEBUTTONUP: 
                    with (button)
                    switch (button) {
                    case SDL_BUTTON_LEFT: 
                        // released
                        if (e.has_klass ("pressed") !is null) {
                            writeln ("has_klass: ", select_klass ("pressed"));
                            e.rem_klass (select_klass ("pressed"));
                            send (SET_E_PROP);
                            send (REDRAW);
                        }
                        break;
                    default:
                    }
                    break;
                default:
                }
                break;
            default:
            }
            break;
        case CHECK:
            break;
        case RADIO:
            break;
        case TEXT:
            break;
        default:
        }
    }

    void
    mod_key_go (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case SDL:
                with (event.sdl.sdl_event)
                if (type == SDL_KEYDOWN)
                switch (key.keysym.sym) {
                    case SDLK_ESCAPE : send (Event.Type.QUIT); break;
                    case SDLK_q      : send!(Event.Type.PLAY, "play", "id") (1); break;
                    case SDLK_w      : send!(Event.Type.PLAY, "play", "id") (2); break;
                    case SDLK_e      : send!(Event.Type.PLAY, "play", "id") (3); break;
                    default:
                }
                break;
            default:
        }
    }

    void
    _on_click_1 (Event* evt) {
        writeln ("_on_click_1");
        with (evt.Type)
        send (Event (Event_play (PLAY,1)));
    }
    void
    _on_click_2 (Event* evt) {
        writeln ("_on_click_2");
        with (evt.Type)
        send (Event (Event_play (PLAY,2)));
    }
    void
    _on_click_3 (Event* evt) {
        writeln ("_on_click_3");
        with (evt.Type)
        send (Event (Event_play (PLAY,3)));
    }


    Klass[] klasses;

    Klass
    new_klass (string name) {
        auto k = new Klass (name);
        klasses ~= k;
        return k;
    }

    Klass
    select_klass (string name) {
        foreach (k; klasses) {
            if (k.name == name)
                return k;
        }
        return null;
    }
}

import e_class : E;

void
send_e_now (O) (E e, Event* evt, O o) {
    e.go (evt,o);
}

void
send_e_now (O) (E e, Event evt, O o) {
    e.go (&evt,o);
}

struct
Gui {
    E e;

    void
    open (O) (O o) {
        tvg_engine_init(4);
        load_ui (o);
    }

    void
    load_ui (O) (O o) {
        import load_ui;
        this.e = load_ui.load_ui (o);
        writeln (this.e);
    }

    E
    select (int x, int y) {
        return select (e,x,y);
    }

    E
    select (E e, int x, int y) {
        if (e !is null)
        if (_select (e,x,y)) {
            // childs
            foreach (c; e.childs) {
                if (_select (c,x,y)) {
                    auto cc = select (c,x,y);
                    if (cc !is null) return cc;
                    else return c;
                }
            }
        }

        return e;
    }

    bool
    _select (E e, int x, int y) {
        auto _xy = e.xy;
        if (_xy.x <= x && _xy.y < y) {
            auto _wh = e.wh;
            if (x < (_xy.x + _wh.w) && y < (_xy.y + _wh.h)) {
                return true;
            }
        }

        return false;
    }
}

// area
//  area
//   area
//   area
//   area
//  area
//   area
//  area
//   area
//   area
//   area

// e panel window canvas
//  e loc1
//   e button 1
//   e button 2
//   e button 3
//  e loc2
//   e button clock
//  e loc3
//   e indicator 1
//   e indicator 2
//   e indicator 3
//
// window
//   x = 0
//   y = top
//   w = screen.w
//   h = 64
//
// loc1
//   x = left
//   y = 0
//   w = 30%
//   h = parent.h
//
// loc2
//   x = center
//   y = 0
//   w = 30%
//   h = parent.h
//
// loc3
//   x = right
//   y = 0
//   w = 30%
//   h = parent.h
//
// button1
//  x = left
//  y = 0
//  w = parent.h
//  h = parent.h
//  icon = start
//
// button2
//  x = left
//  y = 0
//  w = parent.h
//  h = parent.h
//
// button3
//  x = left
//  y = 0
//  w = parent.h
//  h = parent.h

//
// on e
// on klass
// on indent
// on e-end

// on char
