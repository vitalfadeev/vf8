module e_class;

import e_ui : A,perc,Desktop,Color,Canvased;
import std.stdio : writefln;
import std.format : format;

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

        // UPDATE_W
        auto evt3 = Event (UPDATE_W);
        o.go (&evt3);

        // UPDATE_H
        auto evt4 = Event (UPDATE_H);
        o.go (&evt4);

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
    void go (O o, E_ui_childed e, Event* evt);
}

class
E : GO {
    void 
    go (O o, E_ui_childed e, Event* evt) {
        //
    }
}

class
Ex : E {
    Ex    next;
    void* data1;

    override
    void  
    go (O o, E_ui_childed e, Event* evt) {
        writefln ("Event: %s", *evt);
        // ...
        with (Event.Type)
        switch (evt.type) {
            case SET_E_PROP : _set_e_prop (o,e,evt); break;
            case UPDATE_W   : _update_w (o,e,evt); break;
            case UPDATE_H   : _update_h (o,e,evt); break;
            case UPDATE_XY  : _update_xy (o,e,evt); break;
            default:
        }

        // next
        if (next !is null) {
            next.go (o,e,evt);
        }
    }

    void  
    _set_e_prop (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (e) {
            // ...
        }
    }

    void  
    _update_w (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (e) {
            // ...
        }
    }

    void  
    _update_h (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (e) {
            // ...
        }
    }

    void  
    _update_xy (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (e) {
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
    void*      data1;
    A.Coord    x,y,w,h;
    Color      bg;
    Event.Type on_click_send_evt_code;  // PLAY_1
    Canvased   canvased;

    override
    void 
    go (O o, E_ui_childed e, Event* evt) {
        // ...

        // next
        super.go (o,e,evt);
    }
}

class
E_ui_childed : E_ui {
    E_ui_childed l;
    E_ui_childed r;
    E_ui_childed cl;
    E_ui_childed cr;
    E_ui_childed parent;

    override
    void 
    go (O o, E_ui_childed e, Event* evt) {
        // ...

        // next
        super.go (o,e,evt);

        // childs
        for (auto _e = cl; _e !is null; _e = _e.r) {
            _e.go (o,_e,evt);
        }
    }

    E_ui_childed
    add_child (E_ui_childed c) {
        auto t = this;
        auto tr = t.cr;
        if (tr is null) {
            t.cr = c;
            t.cl = c;
        }
        else {
            c.l = tr;
            tr.r = c;
            t.cr = c;
        }
        c.parent = t;

        return c;
    }

    override
    void  
    _update_w (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (A.Type) {
            switch (e.w.type) {
                case _parent_w : this.canvased.w = this.parent.canvased.w; break;
                case _parent_h : this.canvased.w = this.parent.canvased.h; break;
                case _int      : this.canvased.w = this.w._int.a; break;
                case _perc     : this.canvased.w = (cast (float) w._perc.a) * this.parent.canvased.w / 100; break;
                default: this.canvased.w = this.parent.canvased.w;
            }
        }
    }

    override
    void  
    _update_h (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (A.Type) {
            switch (e.h.type) {
                case _parent_w : this.canvased.h = this.parent.canvased.w; break;
                case _parent_h : this.canvased.h = this.parent.canvased.h; break;
                case _int      : this.canvased.h = this.h._int.a; break;
                case _perc     : this.canvased.h = (cast (float) h._perc.a) * this.parent.canvased.h / 100; break;
                default: this.canvased.h = this.parent.canvased.h;
            }
        }
    }

    override
    void  
    _update_xy (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (A.Type) {
            switch (e.x.type) {
                case _left     : _step__at_left (o,e,evt); break;
                case _center   : break;
                case _right    : break;
                case _int      : this.canvased.x = this.x._int.a; break;
                default: 
            }
        }
    }

    void
    _step__at_left (O o, E_ui_childed e, Event* evt) {
        this.canvased.x = evt.update_xy.cursor_x;
        this.canvased.y = evt.update_xy.cursor_y;
        evt.update_xy.cursor_x += this.canvased.w;
        evt.update_xy.cursor_x_max = this.parent.canvased.x + this.parent.canvased.w;
        evt.update_xy.start_x = this.parent.canvased.x;
        if (evt.update_xy.cursor_x > evt.update_xy.cursor_x_max) {
            evt.update_xy.cursor_y += evt.update_xy.line_height;
            evt.update_xy.cursor_x  = evt.update_xy.start_x;
        }        
    }
}

//
//
auto 
e () {
    return new E_ui_childed ();
}
auto
e (E_ui_childed _e) {
    return _e.add_child (new E_ui_childed ());
}
auto
parent (E_ui_childed e) {
    return e.parent;
}

auto window (E_ui_childed e) { return e.add_ex (new Window); }
class
Window : Ex {
    override
    void  
    _set_e_prop (O o, E_ui_childed e, Event* evt) {
        with (e) {
            x = 0;
            y = 0;
            w = Desktop.w;
            h = 64;
        }
    }
}
auto panel (E_ui_childed e) { return e.add_ex (new Panel); }
class Panel  : Ex {}
auto canvas (E_ui_childed e) { return e.add_ex (new Canvas); }
class Canvas : Ex {}
auto loc1 (E_ui_childed e) { return e.add_ex (new Loc1); }
class 
Loc1 : Ex {
    override
    void  
    _set_e_prop (O o, E_ui_childed e, Event* evt) {
        with (e) {
           x = A.Coord.left;
           y = 0;
           w = 33.perc;
           h = A.Coord.parent_h;
        }
    }
}
auto button (E_ui_childed e) { return e.add_ex (new Button); }
class Button : Ex {}
auto _1 (E_ui_childed e) { return e.add_ex (new __1); }
class __1 : Ex {}
auto _2 (E_ui_childed e) { return e.add_ex (new __2); }
class __2 : Ex {}
auto _3 (E_ui_childed e) { return e.add_ex (new __3); }
class __3 : Ex {}
auto loc2 (E_ui_childed e) { return e.add_ex (new Loc2); }
class 
Loc2 : Ex {
    override
    void  
    _set_e_prop (O o, E_ui_childed e, Event* evt) {
        with (e) {
            x = A.Coord.center;
            y = 0;
            w = 34.perc;
            h = A.Coord.parent_h;
        }
    }
}
auto clock (E_ui_childed e) { return e.add_ex (new Clock); }
class 
Clock : Ex {
    override
    void  
    _set_e_prop (O o, E_ui_childed e, Event* evt) {
        with (e) {
            x = A.Coord.center;
            y = 0;
            w = 33.perc;
            h = A.Coord.parent_h;
        }
    }
}
auto loc3 (E_ui_childed e) { return e.add_ex (new Loc3); }
class 
Loc3 : Ex {
    override
    void  
    _set_e_prop (O o, E_ui_childed e, Event* evt) {
        with (e) {
            x = A.Coord.right;
            y = 0;
            w = 33.perc;
            h = A.Coord.parent_h;
        }
    }
}
auto indicator (E_ui_childed e) { return e.add_ex (new Indicator); }
class Indicator : Ex {}


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
}

    enum
    Type {
        CLICK      =  1,
        UPDATE     =  2,
        SET_E_PROP = 11,
        UPDATE_W   = 12,
        UPDATE_H   = 13,
        UPDATE_XY  = 14,
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
    auto type = Event.Type.UPDATE;
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
    float cursor_x;
    float cursor_y;
    float cursor_x_max = 640;
    float start_x = 0;
    float line_height = 64.0;
}


class
O {
    E_ui_childed e;

    void 
    go (Event* evt) {
        e.go (this,e,evt);
    }
}

void
dump_tree (E_ui_childed e, int level=0) {
    import core.stdc.stdio : printf;

    // e
    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    // klasses
    for (auto ex = e.next; ex !is null; ex = ex.next) printf (" %x", ex);
    // properties
    printf (" wh=(%dx%d), c.wh:(%1.1f,%1.1f) , c.xy:(%1.1f,%1.1f)", e.w.type, e.h.type,  e.canvased.w,e.canvased.h,  e.canvased.x,e.canvased.y);
    printf ("\n");

    // childs
    for (auto _e = e.cl; _e !is null; _e = _e.r) {
        dump_tree (_e,level+1);
    }
}
