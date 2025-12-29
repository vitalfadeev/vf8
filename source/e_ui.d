module e_ui;

void
mai () {
    auto e = test ();
    dump_tree (e);
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


alias 
GO  = void function (O* o, E* e, Ex* ex, void* evt);

alias
REG = void*;

// ctx, go
//   go (ctx) {
//     //
//   }
//
// ctx, go
//   go (ctx,evt) {
//     //
//   }
//
// ctx
//   go
//   ctx2
//   go2
//
//   go (ctx,evt) {
//     //
//   }
//
//   go2 (ctx,ctx2,evt) {
//     //
//   }
//
// ctx
//   go
//   [ctx2,go2]
//
//   go (ctx,evt) {
//     foreach ctx2,go2 in [ctx2,go2]
//       go2 (ctx,ctx2,evt)
//   }
//
//   go2 (ctx,ctx2,evt) {
//     //
//   }
//
// ctx
//   go
//   ctx2[]
//
//   go (ctx,evt) {
//     foreach ctx2 in ctx2[]
//       ctx2.go (ctx,ctx2,evt)
//   }
//
// ctx2
//   go (ctx,ctx2,evt) {
//     //
//   }
//   void* data1

struct
O {
    GO go;
    E* e;  // = new E_exed ()

    alias GO  = void function (O* o, void* evt);
}

struct
E {
    GO go;

    static
    void
    _go (O* o, E* e, Ex* ex, void* evt) {
        //
    }
}

struct
Ex {
union {
    GO  go;
    E   e_;
}
    Ex* next;

    static
    void
    _go (O* o, Ex* e, Ex* ex, void* evt) {
        //e.go (o,e,ex,evt);
        each_ex (o,e,ex,evt);
    }

    void
    add_ex (Ex* ex) {
        // find end
        Ex* _pre = &this;
        Ex* _ex  = _pre.next;
        for (; _ex !is null; _pre = _ex, _ex = _ex.next) {
            if (_pre is ex) {
                return;  // skip existent
            }
        }
        _pre.next = ex;  // to end
    }

    bool
    has_ex (Ex* ex) {
        auto _ex = &this;
        for (; _ex !is null; _ex = _ex.next) {
            if (_ex is ex) {
                return true;
            }
        }
        return false;
    }

    void
    del_ex (Ex* ex) {
        auto _pre = &this;
        auto _ex  = _pre.next;
        for (; _ex !is null; _pre = _ex, _ex = _ex.next) {
            if (_ex is ex) {
                _pre.next = _ex.next;
                break;
            }
        }
    }

    static
    void
    each_ex (O* o, Ex* e, Ex* ex, void* evt) {
        for (auto _ex = e.next; _ex !is null; _ex = _ex.next) {
            _ex.go (o,cast(E*)e,_ex,evt);
        }
    }
}



//
alias Code  = int;

struct
E_ui {
union {
    GO     go = cast (GO) &_go;
    E      e_;
    Ex     ex_;     // with next
    Klass  klass_;  // with data1
}
    //
    A.Coord x,y,w,h;
    // layers
    // layer 1
    //   bg
    //   fg
    //   svg
    //   text
    // layer 2
    //   bg
    //   fg
    //   svg
    //   text
    // layer 3
    //   bg
    //   fg
    //   svg
    //   text
    Color   bg;
    Code    on_click_send_evt_code;  // PLAY_1
    //
    Canvased canvased;
    
    //
    static
    void
    _go (O* o, E_ui* e, Klass* k, void* evt) {
        // go
        switch ((cast (Event*) evt).type) {
            case CLICK  : put (o,e,k,e.on_click_send_evt_code); break;
            case UPDATE : on_update (o,e,k,evt); break;
            default:
        }

        // klass.go, klass.go, ...
        Ex.each_ex (o,cast(Ex*)e,cast(Ex*)k,evt);
    }

    enum CLICK  = 1;
    enum UPDATE = 2;

    static
    void
    put (O* o, E_ui* e, Klass* k, Code code) {
        //
    }

    static
    void
    on_update (O* o, E_ui* e, Klass* k, void* evt) {
        // read w
        // write canvased.w
        //
        // read x
        // write canvased.x
        with (e)
        if (w.type == A.Type._perc) {
            canvased.w = 
                (
                    (cast (E_ui_childed*)e).parent
                )
                .e_ui_.canvased.w * w._perc.a / 100;
        }
    }
}

struct
Klass {
union {
    GO      go = cast (GO) &_go;
    E       e_;
    Ex      ex_;
}
    void*   data1;

    static
    void
    _go (O* o, E_ui* e, Klass* k, void* evt) {
        // k.data1
    }

    //
    // e .window
    E_ui*
    opCall (E_ui* e) {
        (cast (Ex*) e).add_ex (cast (Ex*) new Klass (this.go));
        return e;
    }
    E_ui_childed*
    opCall (E_ui_childed* e) {
        e.ex_.add_ex (cast (Ex*) new Klass (this.go));
        return e;
    }
}

struct
E_ui_childed {
union {
    GO    go;
    E     e_;
    Ex    ex_;     // with next
    Klass klass_;  // with data1
    E_ui  e_ui_;
}    
    //
    E_ui_childed* l;
    E_ui_childed* r;
    E_ui_childed* cl;
    E_ui_childed* cr;
    E_ui_childed* parent;

    E_ui_childed*
    add_child (E_ui_childed* c) {
        auto t = &this;
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

    static
    void
    each_child (O* o, E_ui_childed* e, Ex* ex, void* evt) {
        for (auto _e = e.cl; _e !is null; _e = _e.r) {
            _e.go (o,cast(E*)e,ex,evt);
        }
    }
}

//
auto 
e () {
    return new E_ui_childed ();
}
auto
e (E_ui_childed* e) {
    return e.add_child (new E_ui_childed ());
}
auto
parent (E_ui_childed* e) {
    return e.parent;
}

Klass
window = {
    (O* o, E* e, Ex* ex, void* evt) {
        with (cast (E_ui*) e) {
            x = 0;
            y = 0;
            w = Desktop.w;
            h = 64;
        }

        with (cast (Klass*) ex) {
//        if ((cast (Event*) evt).type == UPDATE) {
//            // (cast (Event*) evt).props[x] = 0
//
//            x = 0;
//            //y = top;
//            //w = screen.w;
//            h = 64;
//        }
        }
    }
};

Klass panel;
Klass canvas;
Klass 
loc1 = {
    (O* o, E* e, Ex* ex, void* evt) {
        with (cast (E_ui*) e) {
           x = A.Coord.left;
           y = 0;
           w = 33.perc;
           h = A.Coord.parent_h;
        }
    }
};
Klass button;
Klass _1;
Klass _2;
Klass _3;
Klass 
loc2 = {
    (O* o, E* e, Ex* ex, void* evt) {
        with (cast (E_ui*) e) {
           x = A.Coord.center;
           y = 0;
           w = 34.perc;
           h = A.Coord.parent_h;
        }
    }
};
Klass clock;
Klass 
loc3 = {
    (O* o, E* e, Ex* ex, void* evt) {
        with (cast (E_ui*) e) {
           x = A.Coord.right;
           y = 0;
           w = 33.perc;
           h = A.Coord.parent_h;
        }
    }
};
Klass indicator;

struct
Event {
    uint type;
}

//
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
}

auto
perc (int a) {
    return A.Perc (a);
}

struct
Canvased {
    Coord x,y,w,h;
    Color color;

    alias Color = uint;
    alias Coord = float;
}

struct
Color {
    int a;
}

//
void
dump_tree (E_ui_childed* e, int level=0) {
    import core.stdc.stdio : printf;

    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    for (auto ex = e.ex_.next; ex != null; ex = ex.next) printf (" %x", ex);
    printf ("\n");

    // childs
    for (auto _e = e.cl; _e !is null; _e = _e.r) {
        dump_tree (_e,level+1);
    }

    //foreach (t; WalkTree (e,&skip)) {
    //    printf ("e\n");
    //}
}


auto 
WalkTree (Tree,Skip) (Tree* t, Skip skip) {
    return _WalkTree!(Tree,Skip) (cast (Tree*) t,skip);
}

struct
_WalkTree (Tree,Skip) {
    Tree* t;
    Skip  skip;

    int
    opApply (int delegate (Tree* t) dg) {
        Tree*  next = t;
        Tree* _next = t;

        loop:
            if (skip (cast (Tree*) next)) {
                _next = next;
                goto go_right;
            }

            if (auto result = dg (cast (Tree*) next))
                return result;

            _next = next;

            go_down:   // v
                next = _next.cl;
                if (next !is null)
                    goto loop;  // go_down
            go_right:  // >
                next = _next.r;
                if (next !is null)
                    goto loop;  // go_down
            go_up:     // ^
                next = _next.parent;
                if (next !is null) {
                    _next = next;
                    goto go_right;
                }

        return 0;
    }
}

bool
skip (Tree) (Tree* e) {
    return false;
}


// e .panel .window .canvas
// .e .loc1
//  .e .button ._1
//  .e .button ._2
//  .e .button ._3
// .e .loc2
//  .e .button .clock
// .e .loc3
//  .e .indicator ._1
//  .e .indicator ._2
//  .e .indicator ._3
//
// window
//   .x = 0
//   .y = top
//   .w = screen.w
//   .h = 64
//
// loc1
//   .x = left
//   .y = 0
//   .w = 30%
//   .h = parent.h
//
// loc2
//   .x = center
//   .y = 0
//   .w = 30%
//   .h = parent.h
//
// loc3
//   .x = right
//   .y = 0
//   .w = 30%
//   .h = parent.h
//
// button1
//  .x = left
//  .y = 0
//  .w = parent.h
//  .h = parent.h
//  .icon = start
//
// button2
//  .x = left
//  .y = 0
//  .w = parent.h
//  .h = parent.h
//
// button3
//  .x = left
//  .y = 0
//  .w = parent.h
//  .h = parent.h

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
Rects {
    Rect[] s;  // active rects only

    struct
    Rect {
        int   x,y,w,h;
        void* e;
    }
}
