module e_ui;

auto
test () {
    auto e = new E_ui ();
    return
    e .window //.panel .canvas
    //.e .loc1
    // .e .button ._1  .parent
    // .e .button ._2  .parent
    // .e .button ._3  .parent.parent
    //.e .loc2
    // .e .button .clock  .parent.parent
    //.e .loc3
    // .e .indicator ._1  .parent
    // .e .indicator ._2  .parent
    // .e .indicator ._3  .parent.parent
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
}

struct
E_exed {
union {
    GO    go = cast (GO) &_go;
    E     e;
    Ex    ex;  // klasses  // Klass (go,next,klass_data)
}

    static
    void
    _go (O* o, E_exed* e, Ex* ex, void* evt) {
        //go (o,e,ex,evt);

        // ex.go, ex.go,...
        for (auto _ex = e.ex.next; _ex !is null; _ex = _ex.next) {
            _ex.go (o,cast(E*)e,_ex,evt);
        }
    }

    void
    add_ex (Ex* ex) {
        auto _ex = &this.ex;
        for (; _ex.next !is null; _ex = _ex.next) {
            if (_ex is ex) {
                return;
            }
        }
        _ex.next = ex;
    }

    bool
    has_ex (Ex* ex) {
        auto _ex = &this.ex;
        for (; _ex !is null; _ex = _ex.next) {
            if (_ex is ex) {
                return true;
            }
        }
        return false;
    }

    void
    del_ex (Ex* ex) {
        auto _pre = &this.ex;
        auto _ex  = _pre.next;
        for (; _ex !is null; _pre = _ex, _ex = _ex.next) {
            if (_ex is ex) {
                _pre.next = _ex.next;
                break;
            }
        }
    }
}

struct
Ex {
union {
    GO go;
    E  e;
}
    Ex* next;
}

//
alias Color = uint;
alias Coord = float;
alias Code  = int;

struct
E_ui {
union {
    GO    go = cast (GO) &_go;
    E     e;
    Ex    ex;    // with next
    Klass klass;  // with data1
}
    //
    Coord x,y,w,h;
    Color bg;
    Code  on_click_send_evt_code;  // PLAY_1
    
    //
    static
    void
    _go (O* o, E_ui* e, Klass* k, void* evt) {
        // go
        switch ((cast (Event*) evt).type) {
            case CLICK : put (o,e,e.on_click_send_evt_code); break;
            default:
        }

        // klass.go, klass.go, ...
        k = &e.klass;
        for (; k !is null; k = cast (Klass*) k.ex.next) {
            k.go (o,cast(E*)e,cast(Ex*)k,evt);  // klass.go
        }        
    }

    enum CLICK = 1;

    static
    void
    put (O* o, E_ui* e, Code code) {
        //
    }
}

struct
Klass {
union {
    GO      go = cast (GO) &_go;
    E       e;
    Ex      ex;
}
    void*   data1;

    static
    void
    _go (O* o, E_ui* e, Klass* k, void* evt) {
        // k.data1
    }

    // e .window
    void
    opCall (E_ui* e) {
        (cast (E_exed*) e).add_ex (cast (Ex*) new Klass (this.go));
    }
}

Klass
window = {
    cast (GO) (O* o, E* e, Ex* ex, void* evt) {
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

struct
Event {
    uint type;
}



//

//alias
//Klass = void function (void* o, void* e, void* evt);

//Klass 
//_panel = (void* o, void* e, void* evt) {
//    with (cast (E*) e) {
//        //
//    }
//};

//Klass 
//_window = (void* o, void* e, void* evt) {
//    with (cast (E*) e) {
////        if ((cast (Event*) evt).type == UPDATE) {
////            // (cast (Event*) evt).props[x] = 0
////
////            x = 0;
////            //y = top;
////            //w = screen.w;
////            h = 64;
////        }
//    }
//};


//E* 
//e () {
//    return new E ();
//}

//E* 
//e (E* e) {
//    auto child = new E ();
//    e.add_child (child);
//    return child;
//}

//E*
//panel (E* e) {
//    e.add_klass (_panel);
//    return e;
//}

//E*
//window (E* e) {
//    e.add_klass (_window);
//    return e;
//}

//Klass canvas_klass;
//E*
//canvas (E* e) {
//    e.add_klass (canvas_klass);
//    return e;
//}

//Klass loc1_klass;
//E*
//loc1 (E* e) {
//    e.add_klass (loc1_klass);
//    return e;
//}

//Klass loc2_klass;
//E*
//loc2 (E* e) {
//    e.add_klass (loc2_klass);
//    return e;
//}

//Klass loc3_klass;
//E*
//loc3 (E* e) {
//    e.add_klass (loc3_klass);
//    return e;
//}

//Klass button_klass;
//E*
//button (E* e) {
//    e.add_klass (button_klass);
//    return e;
//}

//Klass _1_klass;
//E*
//_1 (E* e) {
//    e.add_klass (_1_klass);
//    return e;
//}

//Klass _2_klass;
//E*
//_2 (E* e) {
//    e.add_klass (_2_klass);
//    return e;
//}

//Klass _3_klass;
//E*
//_3 (E* e) {
//    e.add_klass (_3_klass);
//    return e;
//}

//Klass clock_klass;
//E*
//clock (E* e) {
//    e.add_klass (clock_klass);
//    return e;
//}

//Klass indicator_klass;
//E*
//indicator (E* e) {
//    e.add_klass (indicator_klass);
//    return e;
//}

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
