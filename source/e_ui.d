module e_ui;

//auto
//test () {
//    return
//    e .panel .window .canvas
//    .e .loc1
//     .e .button ._1  .parent
//     .e .button ._2  .parent
//     .e .button ._3  .parent.parent
//    .e .loc2
//     .e .button .clock  .parent.parent
//    .e .loc3
//     .e .indicator ._1  .parent
//     .e .indicator ._2  .parent
//     .e .indicator ._3  .parent.parent
//    ;
//}


alias 
GO  = void function (O* o, E* e, void* evt);

alias
REG = void*;

struct
Klass_set {
    Klass[8] s;

    auto
    has (Klass k) {
        return 
            (s[0] == k) ||
            (s[1] == k) ||
            (s[2] == k) ||
            (s[3] == k) ||
            (s[4] == k) ||
            (s[5] == k) ||
            (s[6] == k) ||
            (s[7] == k);
    }

    void
    add (Klass k) {
        s[0] = k;
    }
}

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
    E* e;  // = new E_moded ()

    alias GO  = void function (O* o, void* evt);
}

struct
E {
    GO go;

    alias GO  = void function (O* o, E* e, void* evt);
}

struct
E_moded {
union {
    GO    go = &_go;
    E     e;
    E_mod e_mod;  // klasses  // Klass (go,next,klass_data)
}

    static
    void
    _go (O* o, E* e, void* evt) {
        with (cast (E_moded*) e) {
            for (auto _mod = &e_mod; _mod !is null; _mod = _mod.next) {
                _mod.go (o,cast(E*)_mod,evt);
            }
        }
    }

    void
    add_mod (E_mod* mod) {
        auto _mod = &e_mod;
        for (; _mod !is null; _mod = _mod.next) {
            //
        }
        _mod.next = mod;
    }
}

struct
E_mod {
union {
    GO go;
    E  e;
}
    E_mod* next;
}

struct
E_klass {
union {
    GO    go;
    E     e;
    E_mod mod;
}
    void* data1;
}

E_klass
window_klass = {
    (O* o, E* e, void* evt) {
        with (cast (E*) e) {
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



//
struct
_E {
    Klass_set klasses;  // r32,r32
    //
    float  x,y,w,h;
    E*     l;
    E*     r;
    E*     cl;
    E*     cr;
    E*     parent;
    ubyte  bg_r;
    ubyte  bg_g;
    ubyte  bg_b;
    ubyte  bg_a;
    int    on_click_send_evt_code;  // PLAY_1

    auto
    has_klass (Klass k) {
        return klasses.has (k);
    }

    E*
    add_klass (Klass k) {
        klasses.add (k);
        return &this;
    }

    E*
    add_child (E* e) {
        return &this;
    }
}

alias
Klass = void function (void* o, void* e, void* evt);

Klass 
_panel = (void* o, void* e, void* evt) {
    with (cast (E*) e) {
        //
    }
};

Klass 
_window = (void* o, void* e, void* evt) {
    with (cast (E*) e) {
//        if ((cast (Event*) evt).type == UPDATE) {
//            // (cast (Event*) evt).props[x] = 0
//
//            x = 0;
//            //y = top;
//            //w = screen.w;
//            h = 64;
//        }
    }
};


E* 
e () {
    return new E ();
}

E* 
e (E* e) {
    auto child = new E ();
    e.add_child (child);
    return child;
}

E*
panel (E* e) {
    e.add_klass (_panel);
    return e;
}

E*
window (E* e) {
    e.add_klass (_window);
    return e;
}

Klass canvas_klass;
E*
canvas (E* e) {
    e.add_klass (canvas_klass);
    return e;
}

Klass loc1_klass;
E*
loc1 (E* e) {
    e.add_klass (loc1_klass);
    return e;
}

Klass loc2_klass;
E*
loc2 (E* e) {
    e.add_klass (loc2_klass);
    return e;
}

Klass loc3_klass;
E*
loc3 (E* e) {
    e.add_klass (loc3_klass);
    return e;
}

Klass button_klass;
E*
button (E* e) {
    e.add_klass (button_klass);
    return e;
}

Klass _1_klass;
E*
_1 (E* e) {
    e.add_klass (_1_klass);
    return e;
}

Klass _2_klass;
E*
_2 (E* e) {
    e.add_klass (_2_klass);
    return e;
}

Klass _3_klass;
E*
_3 (E* e) {
    e.add_klass (_3_klass);
    return e;
}

Klass clock_klass;
E*
clock (E* e) {
    e.add_klass (clock_klass);
    return e;
}

Klass indicator_klass;
E*
indicator (E* e) {
    e.add_klass (indicator_klass);
    return e;
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
