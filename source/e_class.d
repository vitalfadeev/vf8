module e_class;

import e_ui : A,perc,Desktop,Color;

void
mai () {
    O o = new O ();
    o.e = test ();

    with (Event.Type) {        
        // SET_E_PROP
        auto evt = Event (SET_E_PROP);
        o.go (&evt);
        dump_tree (o.e);

        // UPDATE
        auto evt2 = Event (UPDATE);
        o.go (&evt2);
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
        // ...
        with (Event.Type)
        switch (evt.type) {
            case SET_E_PROP : _set_e_prop (o,e,evt); break;
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
    //Canvased canvased;

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
    Type type;

    enum
    Type {
        CLICK  = 1,
        UPDATE = 2,
        SET_E_PROP = 11,
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

void
dump_tree (E_ui_childed e, int level=0) {
    import core.stdc.stdio : printf;

    // e
    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    // klasses
    for (auto ex = e.next; ex !is null; ex = ex.next) printf (" %x", ex);
    // properties
    printf (" w=%d,h=%d", e.w.type, e.h.type);
    printf ("\n");

    // childs
    for (auto _e = e.cl; _e !is null; _e = _e.r) {
        dump_tree (_e,level+1);
    }
}
