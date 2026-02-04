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

    mixin Switches;

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
        mod_audio_go    (evt);
        mod_key_go      (evt);
        mod_video       (evt);
        mod_ui_go       (evt);
        mod_ui_widget_hotkey (evt,gui.e);
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
            case SDL_QUIT:
                printf ("on SQL QUIT\n");
                send (Event.Type.QUIT);
                break;
            default:
        }
    }

    void
    mod_audio_go (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case PLAY   : audio.play_wav (evt.play.id); break;
            case PLAY_1 : audio.play_wav (1); break;
            case PLAY_2 : audio.play_wav (2); break;
            case PLAY_3 : audio.play_wav (3); break;
            default:
        }
    }

    void
    mod_video (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case WINDOWEVENT:
                with (evt.sdl.window)
                switch (event) {
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
            case PRESS:
                with (evt.press) {
                    auto _mouse_over_e = gui.select (x,y);
                    if (_mouse_over_e !is null) {
                        mod_ui_widget_go (evt,_mouse_over_e);
                        //_mouse_over_e._on.go (evt,_mouse_over_e);
                    }
                }
                break;
            case RELEASE:
                with (evt.release) {
                    auto _mouse_over_e = gui.select (x,y);
                    if (_mouse_over_e !is null) {
                        mod_ui_widget_go (evt,_mouse_over_e);
                        send (Event (Event_click (CLICK, x, y)));
                        //_mouse_over_e._on.go (evt,_mouse_over_e);
                    }
                }
                break;
            case HOTKEY_PRESS:
                with (evt.hotkey) {
                    auto _hotkey_e = cast (E) e;
                    if (_hotkey_e !is null) {
                        mod_ui_widget_go (evt,_hotkey_e);
                        //_hotkey_e._on.go (evt,_hotkey_e);
                    }
                }
                break;
            case HOTKEY_RELEASE:
                with (evt.hotkey) {
                    auto _hotkey_e = cast (E) e;
                    if (_hotkey_e !is null) {
                        mod_ui_widget_go (evt,_hotkey_e);
                        //_hotkey_e._on.go (evt,_hotkey_e);
                    }
                }
                break;
            case CLICK:
                with (evt.click) {
                    auto _mouse_over_e = gui.select (x,y);
                    if (_mouse_over_e !is null) {
                        //_mouse_over_e._on.go (evt,_mouse_over_e);
                    }
                }
                break;
            case MOUSEBUTTONDOWN:
                with (evt.sdl.button)
                switch (button) {
                    case SDL_BUTTON_LEFT: send (Event (Event_click (PRESS,x,y))); break;
                    default:
                }
                break;
            case MOUSEBUTTONUP:
                with (evt.sdl.button)
                switch (button) {
                    case SDL_BUTTON_LEFT: send (Event (Event_click (RELEASE,x,y))); break;
                    default:
                }
                break;
            default:
        }

        // on
        foreach (e; gui.e.childs_recursive) {
            auto rec = e._on.select (evt.type);
            if (rec !is null) {
                // call dg
                if (rec.dg !is null)
                    rec.dg (evt);
                // send event
                if (rec.new_event.type)
                    send (rec.new_event);
                // add klass
                if (rec.add_klass.length) {
                    auto kls = select_klass (rec.add_klass);
                    if (kls !is null)
                        e.add_klass (kls);
                }
                // rem klass
                if (rec.rem_klass.length) {
                    auto kls = select_klass (rec.rem_klass);
                    if (kls !is null)
                        e.rem_klass (kls);
                }
            }
        }
    }

    void
    mod_ui_widget_go (Event* evt, E e) {
        with (e) 
        switch (e.type._etype.a) with (E.Type) {
        case BUTTON:
            switch (evt.type) with (evt.type) {
            case PRESS:
                if (e.has_klass ("pressed") is null) {
                    e.add_klass (select_klass ("pressed"));
                    send (SET_E_PROP);
                    send (REDRAW);
                }
                break;
            case RELEASE: 
                if (e.has_klass ("pressed") !is null) {
                    e.rem_klass (select_klass ("pressed"));
                    send (SET_E_PROP);
                    send (REDRAW);
                }
                break;
            case HOTKEY_PRESS:
                if (e.has_klass ("pressed") is null) {
                    e.add_klass (select_klass ("pressed"));
                    send (SET_E_PROP);
                    send (REDRAW);
                }
                break;
            case HOTKEY_RELEASE:
                if (e.has_klass ("pressed") !is null) {
                    e.rem_klass (select_klass ("pressed"));
                    send (SET_E_PROP);
                    send (REDRAW);
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
    mod_ui_widget_hotkey (Event* evt, E e) {
        auto hotkeys = collect_hotkeys (e);

        with (evt.Type)
        switch (evt.type) {
            case KEYDOWN:
                with (event.sdl)
                foreach (ref hke; hotkeys) {
                    if (hke.hk.length)
                    if (key.keysym.sym == hke.hk[0]) {
                        send (Event (Event_hotkey (HOTKEY_PRESS,cast(void*)hke.e)));
                    }
                }
                break;
            case KEYUP:
                with (event.sdl)
                foreach (ref hke; hotkeys) {
                    if (hke.hk.length)
                    if (key.keysym.sym == hke.hk[0]) {
                        send (Event (Event_hotkey (HOTKEY_RELEASE,cast(void*)hke.e)));
                    }
                }
                break;
            default:
        }

    }

    void
    mod_key_go (Event* evt) {
        with (evt.Type)
        switch (evt.type) {
            case KEYDOWN:
                with (event.sdl)
                with (SDL_Scancode)
                switch (key.keysym.scancode) {
                    case SDL_SCANCODE_ESCAPE : send (Event.Type.QUIT); break;
                    case SDL_SCANCODE_Q      : send (Event (Event_play (PLAY_1,1))); break;
                    case SDL_SCANCODE_W      : send (Event (Event_play (PLAY_2,2))); break;
                    case SDL_SCANCODE_E      : send (Event (Event_play (PLAY_3,3))); break;
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

auto
collect_hotkeys (E e) {
    HKE[] hotkeys;

    foreach (_e; e.childs_recursive) {
        auto hk = _e.hotkey;
        if (hk.type == hk.Type._hotkey) {            
            if (hk._hotkey.a) {
                hotkeys ~= HKE (_e,hk._hotkey.a);
            }
        }
    }

    return hotkeys;
}

struct
HKE {
    E      e;
    string hk;
}

import e_class : E;

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

// key Q -> Play 1
//          btn 1 state pressed
// btn 1 -> btn 1 state pressed
//          Play 1
//
// hotkey
// colect_hotkeys
//   bind HOTKEY, PLAY 1
//   bind CLICK,  PLAY 1

// data.state  pressed | released
//   on data_changed
//      update_binded_widget
//
// e.binded_data
//
// on key press
//   data.state = pressed
//   data.update_binded_widget
// on key release
//   data.state = released
//   data.update_binded_widget
//
// on data
//   if data.state = pressed
//     widget.klasses add pressed
//   if data.state = released
//     widget.klasses rem pressed
//
// on data.state
//   pressed
//     widget.klasses add pressed
//   released
//     widget.klasses rem pressed
//
// data.value 
//   classes
//
// cond
//   classes
//
// o.dg_returned_1
//   add klass
//   else
//   rem klass
// e.on (&o.dg_returned_1, add klass, rem klass)

//
// on button press
//   dg
//     data = x
//     //send DATA_CHANGED
//     //send REDRAW
//
// data = x
//   send DATA_CHANGED
//   send REDRAW
//
// e 
//   DATA_CHANGED
//     data == x ? red : green
//   dynamic_klasses (&dg_data_eq_x, "red", "green")
//   dynamic_klasses (&data.flag_1, "red", "green")
//

// struct
// Data 
//   _x
//   void x (int a) { update_flags; send (DATA_CHANGED); send (REDRAW); }
//   int  x (     ) {}
//   
//   bool flag_1
//   void update_flags () { flag_1 = true; }

// e flag_1!red
// e flag_1_red
// flag_1_red = Flag_klass (&data.flag_1, red)

// e     button pressed red
// flags      1       2   3
// allow_klass red     flag_1
// deny_klass  pressed flag_2


// data
//   flag_1
//   on flag_1 == 1
//     send PLAY_START_1  // and ignore PLAY_START_1  // source data
//   on flag_1 == 0
//     send PLAY_STOP_1
//   on PLAY_START_1      // ignored on flag_1 == 1
//     flag_1 = 1
//     // no emit PLAY_START_1  // PLAY_START_1 == PLAY_START_1
//   on PLAY_STOP_1
//     flag_1 = 0
// widget
//   on PLAY_START_1
//     klass "plaing"
//   on PLAY_STOP_1
//     rem klass "plaing"
//   on CLICK
//     send PLAY_START_1
// key
//   on PRESS
//     send PLAY_START_1
//   on RELEASE
//     send PLAY_STOP_1
// audio
//   on PLAY_START_1
//     play 1.wav
//   on PLAY_STOP_1
//     stop 1.wav

// PLAY_START_1
//   connect data
//   connect widget
//   connect audio
// PLAY_STOP_1
//   connect data
//   connect widget
//   connect audio

// button
//   on PRESS event PLAY_START_1
//   on PLAY_START_1 event LAMP_ON
//   on LAMP_ON add_klass "lamp_on"

// key
//   SDLK_a - is connect name
//   SDLK_a - is out name
//   SDLK_a - is wire name
//
// widget
//   _SDLK_a - is in
//    PRESS  - is out

// key
//  SDLK_a
//    PLAY_1
// audio
//  _PLAY_1
//     play 1.wav
// mouse
//   BTN_DOWN x,y
// button
//  _BTN_DOWN
//    PLAY_1
//  _PLAY_1
//    PRESS
//  _PRESS
//    add_klass press
//
// widget
//  _PLAY_1
//     add klass "play"
//  _BTN_DOWN
//     PLAY_1

mixin template
Switches () {
    //void
    //_key_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case KEY_A: send (PLAY_1); break;
    //        default:
    //    }
    //}

    //void
    //_audio_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case PLAY_1: play ("1.wav"); break;
    //        default:
    //    }
    //}

    //void
    //_mouse_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case BUTTON_LEFT: break;
    //        default:
    //    }
    //}

    //void
    //_button_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case BUTTON_LEFT : send (PLAY_1); break;
    //        case PLAY_1      : send (PRESS);  break;
    //        case PRESS       : add_klass ("press"); break;
    //        default:
    //    }
    //}

    //void
    //_widget_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case PLAY_1      : add_klass ("play"); break;
    //        case BUTTON_LEFT : send (PLAY_1);      break;
    //        default:
    //    }
    //}
}
