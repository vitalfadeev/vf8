module e_class;

import std.stdio  : writefln;
import std.stdio  : writeln;
import std.format : format;
import childs_parent;
import layout;

void
mai () {
    O o = new O ();
    o.e = test ();

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



        // UPDATE_XY
        auto evt5 = Event (UPDATE_XY);
        evt5.update_xy.cursors.length = 1;
        o.go (&evt5);

        // ...
        //auto evt6 = Event (...);
        //o.go (&evt6);

        dump_tree (o.e);
    }
}

auto
test () {
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
    void go (O o, E_ui e, Event* evt);
}

class
E : GO {
    void 
    go (O o, E_ui e, Event* evt) {
        //
    }
}

class
Ex : E {
    Ex    next;
    void* data1;

    override
    void  
    go (O o, E_ui e, Event* evt) {
        writefln ("Event: %s", *evt);
        // ...
        with (evt.Type)
        switch (evt.type) {
            case UPDATE      : _update     (o,e,evt); break;
            case SET_E_PROP  : _set_e_prop (o,e,evt); break;
            case UPDATE_XY   : _update_xy  (o,e,evt); break;
            case DRAW        : _draw       (o,e,evt); break;
            default:
        }

        // next
        if (next !is null) {
            next.go (o,e,evt);
        }
    }

    void  
    _update (O o, E_ui e, Event* evt) {
        //with (o)
        with (e) {
            // ...
        }
    }

    void  
    _set_e_prop (O o, E_ui e, Event* evt) {
        //with (o)
        with (e)
        with (evt.set_e_prop) {
            // ...
        }
    }

    void  
    _update_xy (O o, E_ui e, Event* evt) {
        //with (o)
        with (e) 
        with (evt.update_xy) {
            // ...
        }
    }

    void  
    _draw (O o, E_ui e, Event* evt) {
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
        Ex _ex  = _pre.next;
        for (; _ex !is null; _pre = _ex, _ex = _ex.next) {
            if (_pre is ex) {
                return cast (T) this;  // skip existent
            }
        }
        _pre.next = ex;  // to end
        return cast (T)  this;
    }
}

class
E_ui : Ex {
    mixin Xywh!E_ui;
    void*      data1;
    Color      bg;
    Event.Type on_click_send_evt_code;  // PLLAY_1
    mixin Childs_parent!E_ui;
    mixin Layout!E_ui;

    Get_width get_width;


    override
    void 
    go (O o, E_ui e, Event* evt) {
        // ...

        // next
        super.go (o,e,evt);

        // childs
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP :
                with (evt.set_e_prop)
                foreach (_e; childs) _e.go (o,_e,evt);
                break;
            case UPDATE_XY :
                writefln ("%s: %s", this, childs_layout.a);
                with (evt.update_xy)
                if (has_childs) go_layout (o,e,evt);
                foreach (_e; childs) _e.go (o,_e,evt);
                break;
            default: /*each (o,e,evt);*/
        }
    }

    override
    void  
    _draw (O o, E_ui e, Event* evt) {
        //with (o)
        with (e)
        with (evt.draw) {
            // ...
        }
    }

    void
    each (O o, E e, Event* evt) {
        foreach (_e; childs)
            _e.go (o,_e,evt);
    }

    alias DGO = void delegate (O o, E_ui e, Event* evt);
}

void
layout_fn () {
    // stacked.to_right__align_left
    // stacked.to_right__align_center
    // stacked.to_left
}

void
detect_strategy (O o, E_ui e, Event_update* evt) {
    with (evt) {
        if (e.w.type == e.w.Type._parent_h)
            strategy = Strategy.hw;

        if (e.h.type == e.h.Type._parent_w)
            strategy = Strategy.wh;
    }
}

//
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
    _set_e_prop (O o, E_ui e, Event* evt) {
        with (e) {
            x = 0;
            y = 0;
            w = Desktop.w;
            h = 64;
        }
    }
}
auto panel (E_ui e) { return e.add_ex (new Panel); }
class Panel  : Ex {}
auto canvas (E_ui e) { return e.add_ex (new Canvas); }
class Canvas : Ex {}
auto loc1 (E_ui e) { return e.add_ex (new Loc1); }
class 
Loc1 : Ex {
    override
    void  
    _set_e_prop (O o, E_ui e, Event* evt) {        
        with (e) with (Coord) {
           w = 33.perc;
           h = parent_h;
        }
        with (e) {
           //childs_layout = left_aligned.stacked.to_right;
           childs_layout = A.left_aligned_stacked_to_right;
        }
    }
}
auto button (E_ui e) { return e.add_ex (new Button); }
class Button : Ex {
    override
    void  
    _set_e_prop (O o, E_ui e, Event* evt) {
        with (e) {
           w = Coord.parent_h;
        }
    }    
}
auto _1 (E_ui e) { return e.add_ex (new __1); }
class __1 : Ex {}
auto _2 (E_ui e) { return e.add_ex (new __2); }
class __2 : Ex {}
auto _3 (E_ui e) { return e.add_ex (new __3); }
class __3 : Ex {}
auto loc2 (E_ui e) { return e.add_ex (new Loc2); }
class 
Loc2 : Ex {
    override
    void  
    _set_e_prop (O o, E_ui e, Event* evt) {
        with (e) {
            w = 34.perc;
            h = Coord.parent_h;
        }
        with (e) {
           //childs_layout = center_aligned.stacked.to_right;
           childs_layout = A.center_aligned_stacked_to_right;
        }
    }
}
auto clock (E_ui e) { return e.add_ex (new Clock); }
class 
Clock : Ex {
    override
    void  
    _set_e_prop (O o, E_ui e, Event* evt) {
        with (e) {
            w = 33.perc;
            h = Coord.parent_h;
        }
    }
}
auto loc3 (E_ui e) { return e.add_ex (new Loc3); }
class 
Loc3 : Ex {
    override
    void  
    _set_e_prop (O o, E_ui e, Event* evt) {
        with (e) {
            w = 33.perc;
            h = Coord.parent_h;
        }
        with (e) {
           //childs_layout = right_aligned.stacked.to_left;
           childs_layout = A.right_aligned_stacked_to_left;
        }
    }
}
auto indicator (E_ui e) { return e.add_ex (new Indicator); }
class Indicator : Ex {
    override
    void  
    _set_e_prop (O o, E_ui e, Event* evt) {
        with (e) {
            w = Coord.parent_h;
            h = Coord.parent_h;
        }
    }
}


//
struct
Event {
union {
    Type type;
    Event_click      click;
    Event_update     update;
    Event_set_e_prop set_e_prop;
    Event_update_w   update_w;
    Event_update_h   update_h;
    Event_update_xy  update_xy;
    Event_draw       draw;
}

    enum
    Type {
        CLICK      =  1,
        UPDATE,
        SET_E_PROP = 11,
        UPDATE_W,
        UPDATE_H,
        UPDATE_XY,
        DRAW,
    }

    string
    toString () {
        return format!"Event(%s)" (type);
    }
}


struct
Event_click {
    auto type = Event.Type.CLICK;
}

struct
Event_update {
    auto type     = Event.Type.UPDATE;
    auto strategy = Strategy._;

    enum
    Strategy {
        _,
        wh,
        hw,
    }
}

struct
Event_set_e_prop {
    auto type = Event.Type.SET_E_PROP;
}

struct
Event_update_w {
    auto type = Event.Type.UPDATE_W;
}

struct
Event_update_h {
    auto type = Event.Type.UPDATE_H;
}

struct
Event_update_xy {
    auto  type = Event.Type.UPDATE_XY;
    // left
    float line_height = 64.0;
    Cursor[] cursors;
    auto ref cursor () { import std.range : back; return cursors.back; }  // current cursor
    struct
    Cursor {
        float x = 0;         // start location
        float y = 0;         // 
        float start_x = 0;   // area xy
        float start_y = 0;   //
        float limit_x = 0;   // area (wh from parent + vars)
        float limit_y = 0;   // 
        float total_w = 0;
        float total_h = 0;
    }

    void
    inc_cursor () {
        cursors.length += 1;
        cursor = Cursor ();  // init
    }

    void
    dec_cursor () {
        cursors.length -= 1;
    }

}

struct
Event_draw {
    auto  type = Event.Type.DRAW;
}

class
O {
    E_ui e;

    void 
    go (Event* evt) {
        e.go (this,e,evt);
    }
}

struct
Canvased {
    Coord x,y,w,h;
    Color color;

    alias Coord = float;
}
alias Color = uint;

struct
Desktop {
    static
    int 
    w () {
        return 1366;
    }
    static
    int 
    h () {
        return 768;
    }
}



void
dump_tree (E_ui e, int level=0) {
    import core.stdc.stdio : printf;

    // e
    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    // klasses
    for (auto ex = e.next; ex !is null; ex = ex.next) printf (" %x", ex);
    // properties
    printf (" wh=(%dx%d), c.wh:(%1.1f,%1.1f) , c.xy:(%1.1f,%1.1f)", 
        e.w.type,     e.h.type,  
        e.wh.w, e.wh.h,  
        e.xy.x, e.xy.y);
    printf ("\n");

    // childs
    for (auto _e = e.cl; _e !is null; _e = _e.r) {
        dump_tree (_e,level+1);
    }
}

struct
Get_width {
    FN _get_width = &fixed;

    alias FN = void function ();

    void
    opAssign (FN b) {
        _get_width = b;
    }

    void
    opCall () {
        _get_width ();
    }

    static
    void
    fixed () {
        //
    }

    static
    void
    by_content () {
        //
    }
}



// e
//   e
//
// klass
//   x = left stack
//   w = parent
//
//   x = left stack
//   x = center stack
//   x = right stack



struct
Universal_emitter {
    Rec* a;
    Rec* z;

    alias Type = typeof (Event.type);
    alias CB   = void function (O o, E_ui e, Event* evt);

    void
    check_and_emit (O o, E_ui e, Event* evt) {
        for (auto rec=a; rec !is null; rec = rec.next) {
            if (rec.type == evt.type) {
                rec.cb (o,e,evt);
            }
        }
    }

    void
    connect (Type type, CB cb) {
        auto rec = new Rec (type,cb);

        if (z is null) {
            z = rec;
            a = rec;
        }
        else {
            rec.prev = z;
            z.next = rec;
            z = rec;
        }
    }

    struct
    Rec {
        Type type;
        CB   cb;   // DList!CB
        Rec* prev;
        Rec* next;
    }
}
