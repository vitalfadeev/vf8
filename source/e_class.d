module e_class;

import std.stdio  : writefln;
import std.stdio  : writeln;
import std.format : format;
import childs_parent;
import layout;
import event;

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
interface 
GO {
    void go (E_ui e, Event* evt);
}

class
E : GO {
    void 
    go (E_ui e, Event* evt) {
        //
    }
}

class
Ex : E {
    Ex    next_ex;
    void* data1;

    override
    void  
    go (E_ui e, Event* evt) {
        // ...
        with (evt.Type)
        switch (evt.type) {
            case UPDATE      : _update     (e,evt); break;
            case SET_E_PROP  : _set_e_prop (e,evt); break;
            case LAYOUT      : _layout     (e,evt); break;
            case DRAW        : _draw       (e,evt); break;
            default:
        }

        // next
        if (next_ex !is null) {
            next_ex.go (e,evt);
        }
    }

    void  
    _update (E_ui e, Event* evt) {
        //with (o)
        with (e) {
            // ...
        }
    }

    void  
    _set_e_prop (E_ui e, Event* evt) {
        //with (o)
        with (e)
        with (evt.set_e_prop) {
            // ...
        }
    }

    void  
    _layout (E_ui e, Event* evt) {
        //with (o)
        with (e) 
        with (evt.layout) {
            // ...
        }
    }

    void  
    _draw (E_ui e, Event* evt) {
        //with (o)
        with (e)
        with (evt.draw) {
            // ...
        }
    }

    T
    add_ex (this T) (Ex ex) {
        // find end
        Ex _pre = this;
        Ex _ex  = _pre.next_ex;
        for (; _ex !is null; _pre = _ex, _ex = _ex.next_ex) {
            if (_pre is ex) {
                return cast (T) this;  // skip existent
            }
        }
        _pre.next_ex = ex;  // to end
        return cast (T)  this;
    }

    override
    string
    toString () {
        return typeof(this).stringof;
    }

    auto
    ex_range () {
        alias T = typeof(this);
        return Ex_range!T (this);
    }

    struct
    Ex_range (T) {
        T _this;

        int 
        opApply (scope int delegate(T) dg) {
            int result = 0;

            for (auto _ex = _this.next_ex; _ex !is null; _ex = _ex.next_ex) {
                result = dg (_ex);

                if (result)
                    break;
            }

            return result;
        }
    }    
}

class
E_ui : Ex {
    mixin Event_layout.tpl;
    mixin Event_draw.tpl;
    mixin Event_click.tpl;
    mixin Childs_parent!(typeof(this));

    override
    void 
    go (E_ui e, Event* evt) {
        writefln ("Event: %s", *evt);
        // ...

        // next
        super.go (e,evt);

        // childs
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP :
                with (evt.set_e_prop)
                foreach (_e; childs) _e.go (_e,evt);
                break;
            case LAYOUT :
                writefln ("%s: %s", this, childs_layout.a);
                with (evt.layout)
                if (has_childs) go_layout (e,evt);
                foreach (_e; childs) _e.go (_e,evt);
                break;
            default: /*each (o,e,evt);*/
        }
    }

    override
    void  
    _draw (E_ui e, Event* evt) {
        //with (o)
        with (e)
        with (evt.draw) {
            draw_rect (canvas,xy,wh,fg);
            draw_text (canvas,xy,wh,text);
            foreach (_e; childs) _e.go (_e,evt);
        }
    }

    void
    each (E e, Event* evt) {
        foreach (_e; childs)
            _e.go (_e,evt);
    }

    override
    string
    toString () {
        string s;
        s = typeof(this).stringof ~ "(";
        foreach (_ex; ex_range) {
            s ~= " " ~ _ex.toString;
        }
        s ~= ")";
        return s;

    }
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
    _set_e_prop (E_ui e, Event* evt) {
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
    _set_e_prop (E_ui e, Event* evt) {        
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
    _set_e_prop (E_ui e, Event* evt) {        
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
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
           w = Coord.parent_h;
        }
        with (e) {
           fg = 0xFFFF0000;
        }
    }    
}
auto _1 (E_ui e) { return e.add_ex (new __1); }
class __1 : Ex {
    override string toString () { return typeof(this).stringof; }
}
auto _2 (E_ui e) { return e.add_ex (new __2); }
class __2 : Ex {
    override string toString () { return typeof(this).stringof; }    
}
auto _3 (E_ui e) { return e.add_ex (new __3); }
class __3 : Ex {
    override string toString () { return typeof(this).stringof; }    
}
auto loc2 (E_ui e) { return e.add_ex (new Loc2); }
class 
Loc2 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {
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
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
            w = 33.perc;
            h = Coord.parent_h;
        }
        with (e) {
            fg = 0xFFFFFFFF;
        }
    }
}
auto loc3 (E_ui e) { return e.add_ex (new Loc3); }
class 
Loc3 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {
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
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
            w = Coord.parent_h;
            h = Coord.parent_h;
        }
        with (e) {
           fg = 0xFF0000FF;
        }
    }
}

struct
Desktop {
    static
    int 
    w () {
        import vf.video;
        return WINDOW_DEFAULT_W;
    }
    static
    int 
    h () {
        import vf.video;
        return WINDOW_DEFAULT_H;
    }
}


void
dump_tree (E_ui e, int level=0) {
    import core.stdc.stdio : printf;

    if (e is null) return;

    // e
    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    // klasses
    foreach (ex; e.ex_range) printf (" %x", ex);
    // properties
    printf (" wh=(%dx%d), c.wh:(%1.1f,%1.1f) , c.xy:(%1.1f,%1.1f)", 
        e.w.type,     e.h.type,  
        e.wh.w, e.wh.h,
        e.xy.x, e.xy.y);
    printf ("\n");

    // childs
    foreach (_e; e.childs)
        dump_tree (_e,level+1);
}
