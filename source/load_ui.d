module load_ui;

import e_class;
import event;
import klass;
import layout;
import std.stdio : writeln;


void
mai (T) () {
    O o = new O ();
    o.e = load_ui ();

    with (Event.Type) {        
        // SET_E_PROP
        auto evt = Event (SET_E_PROP);
        o.go (&evt);

        // UPDATE
        auto evt2 = Event (UPDATE);
        o.go (&evt2);

        //with (evt2.update)
        //with (evt2.update.strategy)
        //switch (strategy) {
        //    case wh: {
        //        // UPDATE_W
        //        auto evt3 = Event (UPDATE_W);
        //        o.go (&evt3);
        //        // UPDATE_H
        //        auto evt4 = Event (UPDATE_H);
        //        o.go (&evt4);
        //        break;
        //    }
        //    case hw: {
        //        // UPDATE_H
        //        auto evt4 = Event (UPDATE_H);
        //        o.go (&evt4);
        //        // UPDATE_W
        //        auto evt3 = Event (UPDATE_W);
        //        o.go (&evt3);
        //        break;
        //    }
        //    default:
        //}



        // LAYOUT
        auto evt5 = Event (LAYOUT);
        evt5.layout.cursors.length = 1;
        o.go (&evt5);

        // ...
        //auto evt6 = Event (...);
        //o.go (&evt6);

        dump_tree (o.e);
    }
}

auto
load_ui () {
    return
    e .window .panel .canvas
    .e .loc1
     .e .button ._1  .parent
     .e .button ._2  .parent
     .e .button ._3  .parent.parent
    .e .loc2
     .e .button .clock  .parent.parent
    .e .loc3
     .e .indicator ._1  .parent
     .e .indicator ._2  .parent
     .e .indicator ._3  .parent.parent
    ;
}


//
auto 
e () {
    return new E ();
}
auto
e (E _e) {
    return _e.add_child (new E ());
}
auto
parent (E e) {
    return e.parent;
}

auto window (E e) { return e.add_klass (new Window); }
class
Window : Klass {
    override
    void  
    _set_e_prop (Event* evt, E e) {
        with (e) {
            x = 0;
            y = 0;
            w = Desktop.w;
            h = 64;
        }
        with (e) {
           fg = 0xFF00FF00;
           //     aabbggrr
        }
    }
}
auto panel (E e) { return e.add_klass (new Panel); }
class Panel  : Klass {
    override string toString () { return typeof(this).stringof; }    

    override
    void  
    _set_e_prop (Event* evt, E e) {        
        with (e) {
           childs_layout = A.left_aligned_stacked_to_right;
        }
    }
}
auto canvas (E e) { return e.add_klass (new Canvas); }
class Canvas : Klass {
    override string toString () { return typeof(this).stringof; }
}
auto loc1 (E e) { return e.add_klass (new Loc1); }
class 
Loc1 : Klass {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E e) {        
        with (e) with (Coord) {
           w = 33.perc;
           h = parent_h;
        }
        with (e) {
           //childs_layout = left_aligned.stacked.to_right;
           childs_layout = A.left_aligned_stacked_to_right;
        }
        with (e) {
           fg = 0x88444444;
        }
    }
}
auto button (E e) { return e.add_klass (new Button); }
class Button : Klass {
    // childs
    //   pressed
    //   released
    State state;

    enum
    State {
        RELEASED,
        PRESSED,
    }

    override
    void
    go (Event* evt, E e) {
        switch (state) with (State) {
            case RELEASED : released.go (evt,e); break;
            case PRESSED  : pressed .go (evt,e); break;
            default:
        }
        super.go (evt,e);
    }

    Released released;
    Pressed  pressed;

    struct
    Released {
        string img = "button-released";

        void
        go (Event* evt, E e) {
            //
        }        
    }
    struct
    Pressed {
        string img = "button-pressed";

        void
        go (Event* evt, E e) {
            //
        }        
    }

    override string toString () { return typeof(this).stringof; }

    //
    void draw () {};
    void on () {};

    override
    void  
    _set_e_prop (Event* evt, E e) {
        with (e) {
           w = Coord.parent_h;
        }
        with (e) {
           fg = 0xFFFF0000;
        }
        with (Event.Type)
        with (e) {
           on (CLICK, Event (), &on_click);
        }
    }

    static
    void
    on_click (Event* evt, void* data, void* o, void* e) {
        writeln ("on_click");
        with (cast (Button) e) {
            toggle_pressed ();
        }
    }

    //override
    //void
    //go (Event* evt, E e) {
    //    with (e)
    //    with (evt.Type)
    //    switch (evt.type) {
    //        case CLICK: toggle_pressed (); break;
    //        default:
    //    }
    //    super.go (evt,e);
    //}

    void
    toggle_pressed () {
        is_pressed ? _release () : _press (); 
    }

    bool
    is_pressed () {
        // has ex pressed
        return true;
    }

    void
    _press () {
        // add ex pressed
    }

    void 
    _release () {
        // rem ex pressed
    }
}
class Pressed : Klass {
    override string toString () { return typeof(this).stringof; }
}
auto _1 (E e) { return e.add_klass (new __1); }
class __1 : Klass {
    override string toString () { return typeof(this).stringof; }

    override 
    void  
    _set_e_prop (Event* evt, E e) {
        with (Event.Type)
        with (e) {
            on (CLICK, Event (Event_play (PLAY,1)));
        }
    }
}
auto _2 (E e) { return e.add_klass (new __2); }
class __2 : Klass {
    override string toString () { return typeof(this).stringof; }    

    override 
    void  
    _set_e_prop (Event* evt, E e) {
        with (e) {
            on_click_send_evt_type = Event.Type.PLAY;
            on_click_send_evt_arg  = 2; // Arg (int,string)
        }
        with (Event.Type)
        with (e) {
            on (CLICK, Event (Event_play (PLAY,2)));
        }
    }
}
auto _3 (E e) { return e.add_klass (new __3); }
class __3 : Klass {
    override string toString () { return typeof(this).stringof; }    

    override 
    void  
    _set_e_prop (Event* evt, E e) {
        with (e) {
            on_click_send_evt_type = Event.Type.PLAY;
            on_click_send_evt_arg  = 3; // Arg (int,string)
        }
        with (Event.Type)
        with (e) {
            on (CLICK, Event (Event_play (PLAY,3)));
        }
    }
}
auto loc2 (E e) { return e.add_klass (new Loc2); }
class 
Loc2 : Klass {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E e) {
        with (e) {
            w = 34.perc;
            h = Coord.parent_h;
        }
        with (e) {
           //childs_layout = center_aligned.stacked.to_right;
           childs_layout = A.center_aligned_stacked_to_right;
        }
        with (e) {
            fg = 0x88444444;
        }
    }
}
auto clock (E e) { return e.add_klass (new Clock); }
class 
Clock : Klass {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E e) {
        with (e) {
            w = 33.perc;
            h = Coord.parent_h;
        }
        with (e) {
            fg = 0xFFFFFFFF;
        }
        with (e) {
            on_click_send_evt_type = Event.Type.PLAY;
            on_click_send_evt_arg  = 1; // Arg (int,string)
        }
    }
}
auto loc3 (E e) { return e.add_klass (new Loc3); }
class 
Loc3 : Klass {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E e) {
        with (e) {
            w = 33.perc;
            h = Coord.parent_h;
        }
        with (e) {
            //childs_layout = right_aligned.stacked.to_left;
            childs_layout = A.right_aligned_stacked_to_left;
        }
        with (e) {
            fg = 0x88444444;
        }
    }
}
auto indicator (E e) { return e.add_klass (new Indicator); }
class Indicator : Klass {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E e,) {
        with (e) {
            w = Coord.parent_h;
            h = Coord.parent_h;
        }
        with (e) {
           fg = 0xFF0000FF;
        }
    }
}

