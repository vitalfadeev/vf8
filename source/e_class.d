module e_class;

import std.stdio  : writefln;
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

        // UPDATE_XY
        auto evt5 = Event (UPDATE_XY);
        evt5.update_xy.totals .length = 1;
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
            case SET_E_PROP  : _set_e_prop (o,e,evt); break;
            case UPDATE_W    : _update_w (o,e,evt); break;
            case UPDATE_H    : _update_h (o,e,evt); break;
            case UPDATE_XY   : _update_xy (o,e,evt); break;
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

    void  
    _update_xy_c (O o, E_ui_childed e, Event* evt) {
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
    Event.Type on_click_send_evt_code;  // PLLAY_1
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
        with (Event.Type)
        switch (evt.type) {
            case UPDATE_XY :
                with (A.Type)
                switch (e.x.type) {
                    case _left: 
                        inc_cursor  (o,e,evt);
                        each        (o,e,evt);
                        dec_cursor  (o,e,evt);
                        break;
                    case _center: 
                        inc_total   (o,e,evt); 
                        each        (o,e,evt); 
                        update_xy_c (o,e,evt); 
                        dec_total   (o,e,evt); 
                        break;
                    default: 
                        each        (o,e,evt);
                }
                break;
            default: each (o,e,evt);
        }
    }

    void
    each (O o, E_ui_childed e, Event* evt) {
        for (auto _e = e.cl; _e !is null; _e = _e.r)
            _e.go (o,_e,evt);
    }

    alias DGO = void delegate (O o, E_ui_childed e, Event* evt);

    void
    inc_cursor (O o, E_ui_childed e, Event* evt) {
        evt.update_xy.cursors.length += 1;
    }

    void
    dec_cursor (O o, E_ui_childed e, Event* evt) {
        evt.update_xy.cursors.length -= 1;
    }

    void
    inc_total (O o, E_ui_childed e, Event* evt) {
        evt.update_xy.totals.length += 1;
    }

    void
    dec_total (O o, E_ui_childed e, Event* evt) {
        evt.update_xy.totals.length -= 1;
    }

    void
    update_xy_c (O o, E_ui_childed e, Event* evt) {
        auto dx = e.parent.canvased.w / 2 - evt.update_xy.total.w / 2;
        for (auto _e = e.cl; _e !is null; _e = _e.r)
            _e.canvased.x += dx;
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
        with (A.Type)
        switch (e.w.type) {
            case _parent_w : this.canvased.w = this.parent.canvased.w; break;
            case _parent_h : this.canvased.w = this.parent.canvased.h; break;
            case _int      : this.canvased.w = this.w._int.a; break;
            case _perc     : this.canvased.w = (cast (float) w._perc.a) * this.parent.canvased.w / 100; break;
            default: this.canvased.w = this.parent.canvased.w;
        }
    }

    override
    void  
    _update_h (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (A.Type)
        switch (e.h.type) {
            case _parent_w : this.canvased.h = this.parent.canvased.w; break;
            case _parent_h : this.canvased.h = this.parent.canvased.h; break;
            case _int      : this.canvased.h = this.h._int.a; break;
            case _perc     : this.canvased.h = (cast (float) h._perc.a) * this.parent.canvased.h / 100; break;
            default: this.canvased.h = this.parent.canvased.h;
        }
    }

    override
    void  
    _update_xy (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (A.Type)
        switch (e.x.type) {
            case _left     : _step__left_to_right (o,e,evt); break;
            case _center   : _step__center_to_right (o,e,evt); break;
            case _right    : break;
            case _int      : this.canvased.x = this.x._int.a; break;
            default: 
        }
    }

    override
    void  
    _update_xy_c (O o, E_ui_childed e, Event* evt) {
        //with (o)
        with (A.Type)
        switch (e.x.type) {
            case _center : _step__center_to_right__center (o,e,evt); break;
            default: 
        }
    }

    void
    _step__left_to_right (O o, E_ui_childed e, Event* evt) {
        with (evt.update_xy) {
            this.canvased.x = cursor.x;
            this.canvased.y = cursor.y;
            cursor.x       += this.canvased.w;
            cursor.start_x  = this.parent.canvased.x;
            cursor.limit_x  = this.parent.canvased.x + this.parent.canvased.w;
            if (cursor.x > cursor.limit_x) {
                cursor.y += line_height;  // wrap line
                cursor.x  = cursor.start_x;
            }
        }
    }

    void
    _step__center_to_right (O o, E_ui_childed e, Event* evt) {
        // each child
        //   calc xy, from 0,0
        //   calc total.w
        // each child update xy
        //   x += area.w / 2 - total.w / 2

        with (evt.update_xy) {
            this.canvased.x = cursor.x;
            this.canvased.y = cursor.y;
            cursor.x       += this.canvased.w;
            cursor.start_x  = this.parent.canvased.x;
            cursor.limit_x  = this.parent.canvased.x + this.parent.canvased.w;
            if (cursor.x > cursor.limit_x) {
                cursor.y += line_height;  // wrap line
                cursor.x  = cursor.start_x;
            }

            // update total w
            total.w += this.canvased.w;
        }
    }

    void
    _step__center_to_right__center (O o, E_ui_childed e, Event* evt) {
        // each child
        //   calc xy, from 0,0
        //   calc total.w
        // each child update xy
        //   x += area.w / 2 - total.w / 2

        with (evt.update_xy) {
            //
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
        UPDATE,
        SET_E_PROP = 11,
        UPDATE_W,
        UPDATE_H,
        UPDATE_XY,
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
        float limit_x = 0;   // area (xy+wh from parent + vars)
        float limit_y = 0;   // 
    }
    // center
    Total[] totals;
    auto ref total () { import std.range : back; return totals.back; }  // current total
    struct
    Total {
        float w = 0;
        float h = 0;
    }
}


class
O {
    E_ui_childed e;

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

struct
A {
    Coord x;
    Coord y;

    struct
    Coord {
        Type     type;
    union {
        Int      _int;
        Perc     _perc;
        Left     _left;
        Center   _center;
        Right    _right;
        Parent_w _parent_w;
        Parent_h _parent_h;
    }

        void
        opAssign (int b) {
            type = Type._int;
            _int = Int (b);
        }
        void
        opAssign (Int b) {
            type = Type._int;
            _int = b;
        }
        void
        opAssign (Perc b) {
            type = Type._perc;
            _perc = b;
        }
        void
        opAssign (Left b) {
            type = Type._left;
            _left = b;
        }
        void
        opAssign (Center b) {
            type = Type._center;
            _center = b;
        }
        void
        opAssign (Right b) {
            type = Type._right;
            _right = b;
        }
        void
        opAssign (Parent_w b) {
            type = Type._parent_w;
            _parent_w = b;
        }
        void
        opAssign (Parent_h b) {
            type = Type._parent_h;
            _parent_h = b;
        }

        static left     = Left ();
        static center   = Center ();
        static right    = Right ();
        static parent_h = Parent_h ();
    }

    enum
    Type {
        _,
        _int,
        _perc,
        _left,
        _center,
        _right,
        _parent_h,
        _parent_w,
    }

    struct
    Int {
        int a;
    }

    struct
    Perc {
        int a;

        //auto 
        //opBinaryRight (string op : "*") (float rhs) {
        //    return a * rhs;
        //}
    }

    struct
    Left {
        int a;
    }

    struct
    Center {
        int a;
    }

    struct
    Right {
        int a;
    }

    struct
    Parent_h {
        int a;
    }

    struct
    Parent_w {
        int a;
    }
}

auto
perc (int a) {
    return A.Perc (a);
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
