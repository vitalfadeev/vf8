module vf.o_base;

import vf.types       : GO,REG;
import vf.input       : Input,Event;
import vf.local_input : Local_input;
import vf.audio       : Audio;
import vf.video       : Video;
import importc;
import std.conv : to;

enum       EVT_UI          = 0x0200;
enum ulong OPEN            = (6             << 16) | EVT_UI;

///
struct
O {
    GO          go = &_go;
    Input       input;
    Local_input!Event local_input;
    Event       event;
    Audio       audio;
    Video       video;
    void*       ego;
    //
    Style       style;
    struct
    Style {
        Font  font;
        Color bg;
        Color fg;

        struct
        Font {
            string name;
            int    size;
            void*  ptr;
        }
        struct
        Color {
            int a;
        }
    }
    // update
    // output
    // wait

    void
    open () {
        SDL_Init (SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS);
        audio.open ();
        video.open ();
        input.open ();
        local_input.open ();
    }

    // base
    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        // send OPEN
        {
            Event event;
            event.type           = SDL_USEREVENT;
            event.user.code      = OPEN;
            event.user.data1     = null;
            event.user.data2     = null;
            event.user.timestamp = SDL_GetTicks ();
            _go2 (o,e,&event,event.type);
        }

        // each input event
        with (cast(O*)o) {
            ego = e;
            evt = &event;

            while (go !is null) {
                if (input.read (cast (Event*) evt)) {
                    _go2 (o,e,evt,d);
                }
            }
        }
    }

    // with local input
    static
    void
    _go2 (void* o, void* e, void* evt, REG d) {
        with (cast(O*)o) {
            // process input event
            d = event.type;
            _go3 (o,e,evt,d);

            // each local input event
            while (!local_input.empty) {
                local_input.read (cast (Event*) evt);
                // process local input event
                d = event.type;
                _go3 (o,e,evt,d);
            }
        }
    }

    // with map
    static
    void
    _go3 (void* o, void* e, void* evt, REG d) {
        with (cast(O*)o) {
            if (e !is null) {
                (cast (GO) e) (o,e,evt,d);
            }
        }
    }
}

// input  line
// direct line
// 1   2   3   4   5   6   7
// key key key             key
//             drt drt drt 

// map
//   to text
//   text to map
//
// map
//   to_text
// editor
//   fields
//     lineno,inlinepos  // x,y
//     complete_list
//   complete_list
// text
//   to_map
//

void
send_now (int TYP, int COD) (void* o, void* e, void* evt, REG d, void* data1) {
    assert (TYP == SDL_USEREVENT);
    Event event;
    event.type           = TYP;
    event.user.code      = COD;
    event.user.data1     = data1;
    event.user.data2     = null;
    event.user.timestamp = SDL_GetTicks ();
    (cast (GO) ((cast(O*)o).ego)) (o,e,&event,TYP);
}

void
send (int TYP, int COD) (void* o, void* e, void* evt, REG d) {
    assert (TYP == SDL_USEREVENT);
    Event event;
    event.type           = TYP;
    event.user.code      = COD;
    event.user.data1     = null;
    event.user.data2     = null;
    event.user.timestamp = SDL_GetTicks ();
    (cast(O*)o).local_input.put (&event);
}

void
send_d_code (int TYP) (void* o, void* e, void* evt, REG d) {
    assert (TYP == SDL_USEREVENT);
    Event event;
    event.type           = TYP;
    event.user.code      = d.to!int;
    event.user.data1     = null;
    event.user.data2     = null;
    event.user.timestamp = SDL_GetTicks ();
    (cast(O*)o).local_input.put (&event);
}
