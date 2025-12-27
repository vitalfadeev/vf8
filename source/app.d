import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.input        : Event;
import vf.local_input  : Local_input;
import importc;

import mod.quit   : mod_quit_go = go,go_quit;
import mod.player : mod_player_go = go;
import mod.print  : mod_print_go = go,go_printf;
import mod.send   : mod_send_go = go,go_send;
import mod.ui     : mod_ui_go = go;
import mod.key    : mod_key_go = go;
import mod.ui : Uni_e;

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
    // event loop
    o.go (&o,&_app_ego,null,0);
}

void
_app_ego (void* o, void* e, void* evt, REG d) {
    mod_quit_go   (o,e,evt,d);
    mod_player_go (o,e,evt,d);
    mod_ui_go     (o,e,evt,d);
    mod_key_go    (o,e,evt,d);
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



void
mai () {
    O2 o;
    o ~= O2_event (O2.Open,"file.ui");
    // event loop
    o.go ();
}

void
O2_level2_ego (void* o, void* e, void* evt, REG d) {
    with (cast (O2*) o)
    switch (evt) {
        case open              : O2_open (evt.file_name); break;
        case indent_start      : ego = &O2_ego_indent; break;
        case indent_end        : ego = &O2_ego_after_indent; break;
        case indented_e_start  : ego = &O2_ego_after_indented_e; break;
        case indented_e_klass_name_start : break;
        case indented_e_klass_name_end   : break;
        case e_start           : break;
        case klass_name_start  : break;
        case klass_name_end    : break;
        case ignore_start      : break;
        case ignore_end        : break;
        default:
    }
}

void
O2_ego (void* o, void* e, void* evt, REG d) {
    with (cast (O2*) o)
    switch (evt) {
        case ' '  : emit (indent_start); break;
        case 'e'  : break;
        case '\n' : break;
        default:
    }
}

void
O2_ego_indent (void* o, void* e, void* evt, REG d) {
    with (cast (O2*) o)
    switch (evt) {
        case ' ' : break;
        default  : emit (indent_end); break;
    }
}

void
O2_ego_after_indent (void* o, void* e, void* evt, REG d) {
    with (cast (O2*) o)
    switch (evt) {
        case 'e'  : emit (indented_e_start); break;
        case '\n' : emit (eol); break;
        default   : ego = &O2_ego_ignore; emit (ignore_start); break;
    }
}

void
O2_ego_after_indented_e (void* o, void* e, void* evt, REG d) {
    with (cast (O2*) o)
    switch (evt) {
        case ' '  : emit (space); break;
        case '\n' : emit (eol); break;
        default   : emit (indented_e_klass_name_start); break;
    }
}

void
O2_ego_ignore (void* o, void* e, void* evt, REG d) {
    with (cast (O2*) o)
    switch (evt) {
        case '\n' : ego = &O2_ego; emit (ignore_end); break;
        default   :
    }
}

alias
O2 = _O2!(O2_input,Local_input!O2_event,O2_event,O2_ego);

struct
_O2 (Input,Local_input,Event,alias base_ego) {
    GO          __go = &_go;
    Input       input;
    Local_input local_input;
    Event       event;
    GO          ego = &base_ego;  // current

    alias O = typeof(this);

    enum {
        Open = 1,
    };

    void
    go () {
        this.__go (&this,ego,null,0);
    }

    void
    opAssign (GO b) {
        ego = b;
    }

    void
    opOpAssign (string op : "~") (Event b) {
        local_input.put (&b);
    }

    // base
    static
    void
    _go (void* o, void* e, void* evt, REG d) {
        // each input event
        with (cast(O*)o) {
            ego = cast (GO) e;
            evt = &event;

            while (__go !is null) {
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
            _go3 (o,e,evt,d);

            // each local input event
            while (!local_input.empty) {
                local_input.read (cast (Event*) evt);
                // process local input event
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

struct
O2_input {
    void
    open (string filename) {
        // open file
    }

    bool 
    read (O2_event* event) {
        return (SDL_WaitEvent (event) == 1);
    }
}

void
O2_open (string file_name) {
    input.open ();
    local_input.open ();
}

struct
O2_event {
    dchar  c;
    size_t pos_a;
    size_t pos_b;

    this (uint type, string str) {
        //
    }
}

// start
//   'e' : name_start
//   ' ' : indent_start
//   def : name_start
//
// name_start
//   ' '  : name_end
//   '\n' : name_end
//   def  : name
//
// indent_start
//   ' '  : indent
//   '\n' : indent_end
//   def  : indent_end
//
// name_end
//   if (range == "e") name_e
//   else              name_klass
//
// indent_end
// 

// name_start pos
// name_end   pos

// open
//  ...

// klass
//  set (pid, void*)
//   swtich (pid)
//    case x: e.x = value
//    case y: e.y = value
//
// klass
//  Pvalue[Pid.max] values;
//
// enum 
// Pid {
//  name
//  x
//  y
// }
//
// Pvalue
//   type none|string

// o ~= Event (OPEN,filename);
// o.go ();
// o  = &O2_ego_indent;
