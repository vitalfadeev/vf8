module load_ui;

import e_class;
import event;
import layout;


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
    return new E_ui ();
}
auto
e (E_ui _e) {
    return _e.add_child (new E_ui ());
}
auto
parent (E_ui e) {
    return e.parent;
}

auto window (E_ui e) { return e.add_ex (new Window); }
class
Window : Ex {
    override
    void  
    _set_e_prop (Event* evt, E_ui e) {
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
auto panel (E_ui e) { return e.add_ex (new Panel); }
class Panel  : Ex {
    override string toString () { return typeof(this).stringof; }    

    override
    void  
    _set_e_prop (Event* evt, E_ui e) {        
        with (e) {
           childs_layout = A.left_aligned_stacked_to_right;
        }
    }
}
auto canvas (E_ui e) { return e.add_ex (new Canvas); }
class Canvas : Ex {
    override string toString () { return typeof(this).stringof; }
}
auto loc1 (E_ui e) { return e.add_ex (new Loc1); }
class 
Loc1 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E_ui e) {        
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
auto button (E_ui e) { return e.add_ex (new Button); }
class Button : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E_ui e) {
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
        with (cast (Button) e) {
            toggle_pressed ();
        }
    }

    //override
    //void
    //go (Event* evt, E_ui e) {
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
class Pressed : Ex {
    override string toString () { return typeof(this).stringof; }
}
auto _1 (E_ui e) { return e.add_ex (new __1); }
class __1 : Ex {
    override string toString () { return typeof(this).stringof; }

    override 
    void  
    _set_e_prop (Event* evt, E_ui e) {
        with (Event.Type)
        with (e) {
            on (CLICK, Event (Event_play (PLAY,1)));
        }
    }
}
auto _2 (E_ui e) { return e.add_ex (new __2); }
class __2 : Ex {
    override string toString () { return typeof(this).stringof; }    

    override 
    void  
    _set_e_prop (Event* evt, E_ui e) {
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
auto _3 (E_ui e) { return e.add_ex (new __3); }
class __3 : Ex {
    override string toString () { return typeof(this).stringof; }    

    override 
    void  
    _set_e_prop (Event* evt, E_ui e) {
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
auto loc2 (E_ui e) { return e.add_ex (new Loc2); }
class 
Loc2 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E_ui e) {
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
auto clock (E_ui e) { return e.add_ex (new Clock); }
class 
Clock : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E_ui e) {
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
auto loc3 (E_ui e) { return e.add_ex (new Loc3); }
class 
Loc3 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E_ui e) {
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
auto indicator (E_ui e) { return e.add_ex (new Indicator); }
class Indicator : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (Event* evt, E_ui e,) {
        with (e) {
            w = Coord.parent_h;
            h = Coord.parent_h;
        }
        with (e) {
           fg = 0xFF0000FF;
        }
    }
}

