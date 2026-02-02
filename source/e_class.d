module e_class;

import std.stdio  : writefln;
import std.stdio  : writeln;
import std.format : format;
import attrs;
import klass;
import childs_parent;
import layout;
import event;
import on;
import app : O=O3;
import std.string : toStringz;

//
interface 
GO {
    void go (Event* evt);
}

class
E_base {
    void 
    go (Event* evt) {
        //
    }
}

class
E {
    Type     type;
    mixin    Attrs;
    mixin    Klass.tpl;
    mixin    Event_layout.tpl;
    mixin    Event_draw.tpl;
    mixin    Event_click.tpl;
    mixin    Childs_parent!(typeof(this));
    On!Event on;

    void 
    go (Event* evt, O o) {
        //
    }

    void
    set_e_prop (Klass k) {
        foreach (key,value; k.attrs) {
            if (value.type)
                this.attrs[key] = value;
        }
    }

    //override
    //void  
    //_draw (E e, Event* evt) {
    //    //with (o)
    //    with (e)
    //    with (evt.draw) {
    //        draw_rect (canvas,xy,wh,fg);
    //        draw_text (canvas,xy,wh,text);
    //        foreach (_e; childs) _e.go (_e,evt);
    //    }
    //}

    void
    each (Event* evt, O o) {
        foreach (_e; childs)
            _e.go (evt,o);
    }

    override
    string
    toString () {
        string s;
        s = typeof(this).stringof ~ "(";
        foreach (k; klasses) {
            s ~= " " ~ k.toString;
        }
        s ~= ")";
        return s;

    }

    enum 
    Type {
        _,
        BUTTON,
        CHECK,
        RADIO,
        TEXT,
        TEXTAREA,
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
dump_tree (E e) {
    import core.stdc.stdio : printf;
    foreach (_e; e.childs_recursive) {
        for (auto i = _e.level; i > 0; i--)  printf ("  ");
        printf ("e");
        foreach (k; _e.klasses) printf (" %s", k.toString.toStringz);
        printf (" wh=(%dx%d), c.wh:(%1.1f,%1.1f) , c.xy:(%1.1f,%1.1f)", 
            _e.w.type,     _e.h.type,  
            _e.wh.w, _e.wh.h,
            _e.xy.x, _e.xy.y);
        printf ("\n");
    }
}

uint
level (E e) {
    uint a;
    for (;e !is null; e = e.parent )
        a++;
    return a;
}

void
dump_tree2 (E e, int level=0) {
    import core.stdc.stdio : printf;

    if (e is null) return;

    // e
    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    // klasses
    foreach (k; e.klasses) printf (" %s", k.toString.toStringz);
    // properties
    printf (" wh=(%dx%d), c.wh:(%1.1f,%1.1f) , c.xy:(%1.1f,%1.1f)", 
        e.w.type,     e.h.type,  
        e.wh.w, e.wh.h,
        e.xy.x, e.xy.y);
    printf ("\n");

    // childs
    foreach (_e; e.childs)
        dump_tree2 (_e,level+1);
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

// e
//   e button
//   e button pressed
//   e button released
//   e button undefined
//   e
//   e button group pressed
//   e button group
//   e button group
//
// button
//   img = btn-released
//   state = pressed                      // auto-dublicate stato by adding klass "pressed"
//   state = pressed,released
//   state = released,pressed
//   state = pressed,released,undefined   // 1st sstate - current, rotate, next released
//   state =         released,undefined,pressed  
//   state =                  undefined,pressed,released
//
// pressed
//   img = btn-pressed
