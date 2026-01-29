module e_class;

import std.stdio  : writefln;
import std.stdio  : writeln;
import std.format : format;
import childs_parent;
import layout;
import event;
import on;

//
interface 
GO {
    void go (Event* evt, E_ui e);
}

class
E : GO {
    void 
    go (Event* evt, E_ui e) {
        //
    }
}

class
Ex : E {
    Ex    next_ex;
    void* data1;

    override
    void  
    go (Event* evt, E_ui e) {
        // ...
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP  : _set_e_prop (evt,e); break;
            //case UPDATE      : _update     (e,evt); break;
            //case LAYOUT      : _layout     (e,evt); break;
            //case DRAW        : _draw       (e,evt); break;
            default:
        }

        // next
        if (next_ex !is null) {
            next_ex.go (evt,e);
        }
    }

    //void  
    //_update (E_ui e, Event* evt) {
    //    //with (o)
    //    with (e) {
    //        // ...
    //    }
    //}

    void  
    _set_e_prop (Event* evt, E_ui e) {
        //with (o)
        with (e)
        with (evt.set_e_prop) {
            // ...
        }
    }

    //void  
    //_layout (E_ui e, Event* evt) {
    //    //with (o)
    //    with (e) 
    //    with (evt.layout) {
    //        // ...
    //    }
    //}

    //void  
    //_draw (E_ui e, Event* evt) {
    //    //with (o)
    //    with (e)
    //    with (evt.draw) {
    //        // ...
    //    }
    //}

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
    On!Event on;

    override
    void 
    go (Event* evt, E_ui e) {
        writefln ("Event: %s", *evt);

        // next
        Ex.go (evt,e);

        // universal event emitter
        //universal_event_emitter.go (evt.type);

        // childs
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP :
                with (evt.set_e_prop)
                foreach (_e; childs) _e.go (evt,_e);
                break;
            case LAYOUT :
                writefln ("%s: %s", this, childs_layout.a);
                with (evt.layout)
                if (has_childs) go_layout (e,evt);
                foreach (_e; childs) _e.go (evt,_e);
                break;
            case DRAW :
                with (e)
                with (evt.draw) {
                    draw_rect (canvas,xy,wh,fg);
                    draw_text (canvas,xy,wh,text);
                    foreach (_e; childs) _e.go (evt,_e);
                }
                break;
            default: /*each (o,e,evt);*/
        }
    }


    //override
    //void  
    //_draw (E_ui e, Event* evt) {
    //    //with (o)
    //    with (e)
    //    with (evt.draw) {
    //        draw_rect (canvas,xy,wh,fg);
    //        draw_text (canvas,xy,wh,text);
    //        foreach (_e; childs) _e.go (_e,evt);
    //    }
    //}

    void
    each (Event* evt) {
        foreach (_e; childs)
            _e.go (evt,_e);
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

// 255 classes
// e
//   klass[4] klasses
//
// klasses_registry
//   klass[256] s
//
// pressed
//   bg = 0xCCCCCCCC;
//  
//  klasses_registry[pressed] = Klass {
//    //
//  }
//  auto pressed = klasses.register (
//    //
//  );
//

