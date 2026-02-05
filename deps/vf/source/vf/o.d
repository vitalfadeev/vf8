module vf.o;

import core.stdc.stdio : printf;
import std.stdio       : writeln;
import vf.o_base       : O_base;
import vf.event        : Event;
import vf.event        : Event_click,Event_play,Event_draw;;
import vf.local_input  : Local_input;
import vf.audio        : Audio;
import vf.video        : Video;
import vf.gui          : Gui;
import vf.e_class      : E;
import vf.klass        : Klass;
import vf.attrs        : Calculated;
import importc;


class
O : O_base!(Event) {
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
    go () {
        with (Event.Type) {            
            send_now (OPEN);
            send_now (UPDATE);
            send_now (SET_E_PROP);
            send_now (LAYOUT);
        }
        super.go ();
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
                printf ("on SDL_QUIT\n");
                send (QUIT);
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
                        send_now (Event (Event_draw (DRAW,video.canvas)));
                        video.draw_end   (this,evt);
                        break;
                    case SDL_WINDOWEVENT_CLOSE: 
                        send (QUIT);
                        break;
                    default:
                }
                break;
            case REDRAW:
                video.draw_start (this,evt);
                send_now (Event (Event_draw (DRAW,video.canvas)));
                video.draw_end   (this,evt);
                break;
            default:
        }
    }

    void
    mod_ui_go (Event* evt) {
        writeln (evt.type);
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP:
                //import load_ui_2 : Data,Data_range;
                //Data[] datas = [Data("1","1"),Data("2","2")];
                //auto data_range = Data_range!Data (datas);
                with (evt.set_e_prop)
                foreach (e; gui.e.childs_recursive ()) {
                    foreach (k; e.klasses)  {
                        e.set_e_prop (k);
                        // map data to e
                        //if (!data_range.empty)
                        //if (k.data_mapper !is null) {
                        //    k.data_mapper (k,evt,e,data_range.front);
                        //    data_range.popFront ();
                        //}
                    }
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
                        //draw_text (canvas,xy,wh,text);
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
        bool redraw = false;
        uint code;
        uint modifiers;
        uint x,y;
        switch (evt.type) with (evt.type) {
            case MOUSEBUTTONDOWN : code = evt.sdl.button.button; modifiers = SDL_GetModState (); x = evt.sdl.button.x; y = evt.sdl.button.y; break;
            case MOUSEBUTTONUP   : code = evt.sdl.button.button; modifiers = SDL_GetModState (); x = evt.sdl.button.x; y = evt.sdl.button.y; break;
            case KEYDOWN         : code = evt.sdl.key.keysym.scancode; modifiers = evt.sdl.key.keysym.mod; break;
            case KEYUP           : code = evt.sdl.key.keysym.scancode; modifiers = evt.sdl.key.keysym.mod; break;
            default:
        }
        modifiers &= (KMOD_CTRL | KMOD_SHIFT | KMOD_ALT | KMOD_GUI);
        foreach (e; gui.e.childs_recursive) {
            // check mouse widget by xy
            with (evt.type)
            if (evt.type == MOUSEBUTTONDOWN || evt.type == MOUSEBUTTONUP) {
                if (gui._select (e,x,y))
                    {} // allow
                else
                    continue;
            }

            // on
            auto rec = e._on.select (evt.type,code,modifiers);
            if (rec !is null) {
                // call dg
                if (rec.dg !is null) {
                    rec.dg (evt);
                    redraw = true;
                }
                // send event
                if (rec.new_event.type) {
                    send (rec.new_event);
                    redraw = true;
                }
                // add klass
                if (rec.klass.length)
                if (rec.klass[0] != '-') {
                    auto kls = select_klass (rec.klass);
                    if (kls !is null) {
                        e.add_klass (kls);
                        redraw = true;
                    }
                }
                // rem klass
                if (rec.klass.length)
                if (rec.klass[0] == '-') {
                    auto kls = select_klass (rec.klass[1..$]);
                    if (kls !is null) {
                        e.rem_klass (kls);
                        redraw = true;
                    }
                }
            }

            with (Event.Type)
            if (redraw) {
                send (SET_E_PROP);
                send (REDRAW); // xy,wh
            }
        }
    }

    void
    mod_ui_widget_go (Event* evt, E e) {
        with (E.Type)
        with (e) 
        switch (e.type._etype.a)  {
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
        //auto hotkeys = collect_hotkeys (e);

        with (evt.Type)
        switch (evt.type) {
            case KEYDOWN:
                //with (event.sdl)
                //foreach (ref hke; hotkeys) {
                //    if (hke.hk.length)
                //    if (key.keysym.sym == hke.hk[0]) {
                //        send (Event (Event_hotkey (HOTKEY_PRESS,cast(void*)hke.e)));
                //    }
                //}
                break;
            case KEYUP:
                //with (event.sdl)
                //foreach (ref hke; hotkeys) {
                //    if (hke.hk.length)
                //    if (key.keysym.sym == hke.hk[0]) {
                //        send (Event (Event_hotkey (HOTKEY_RELEASE,cast(void*)hke.e)));
                //    }
                //}
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
            case KEYUP:
                with (event.sdl)
                with (SDL_Scancode)
                switch (key.keysym.scancode) {
                    case SDL_SCANCODE_Q      : send (Event (Event_play (PLAY_1_STOP,1))); break;
                    case SDL_SCANCODE_W      : send (Event (Event_play (PLAY_2_STOP,1))); break;
                    case SDL_SCANCODE_E      : send (Event (Event_play (PLAY_3_STOP,1))); break;
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
