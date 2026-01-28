import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.local_input  : Local_input;
import vf.audio       : Audio;
import vf.video       : Video;
import event;
import importc;
import std.stdio : writeln;


extern(C)
void 
main () {
    auto o = new O3 ();
    o.open ();

    o.send_now (Event.Type.OPEN);
    o.send_now (Event.Type.UPDATE);
    o.send_now (Event.Type.SET_E_PROP);
    o.send_now (Event.Type.LAYOUT);

    import e_class : dump_tree;
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
        gui.open ();
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
            default:
        }
    }

    void
    mod_ui_go (Event* evt) {
        if (gui.e !is null)
        with (evt.Type)
        switch (evt.type) {
            case UPDATE:
            case SET_E_PROP:
            case LAYOUT:
            case DRAW:
                gui.e.go (gui.e,evt);
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
}

import e_class : E_ui;
alias E = E_ui;

struct
Gui {
    E_ui e;

    void
    open () {
        tvg_engine_init(4);
        load_ui ();
    }

    void
    load_ui () {
        import e_class;
        this.e = e_class.load_ui ();
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



