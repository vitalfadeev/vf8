module e_class;

import std.stdio  : writefln;
import std.stdio  : writeln;
import std.format : format;
import klass;
import childs_parent;
import layout;
import event;
import on;
import std.string : toStringz;

//
interface 
GO {
    void go (Event* evt);
}

class
E_base {
    void 
    go (Event* evt, E_base e) {
        //
    }
}

class
E {
    mixin Klass.tpl;
    mixin Event_layout.tpl;
    mixin Event_draw.tpl;
    mixin Event_click.tpl;
    mixin Childs_parent!(typeof(this));
    On!Event on;

    void 
    go (Event* evt) {
        writefln ("Event: %s", *evt);

        // next
        foreach (k; klasses) k.go (evt,this);

        // universal event emitter
        //universal_event_emitter.go (evt.type);

        // childs
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP :
                with (evt.set_e_prop)
                foreach (_e; childs) _e.go (evt);
                break;
            case LAYOUT :
                writefln ("%s:", this, childs_layout.a);
                with (evt.layout)
                if (has_childs) go_layout (evt);
                foreach (_e; childs) _e.go (evt);
                break;
            case DRAW :
                with (evt.draw) {
                    draw_rect (canvas,xy,wh,fg);
                    draw_text (canvas,xy,wh,text);
                    foreach (_e; childs) _e.go (evt);
                }
                break;
            default: /*each (o,e,evt);*/
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
    each (Event* evt) {
        foreach (_e; childs)
            _e.go (evt);
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
dump_tree (E e, int level=0) {
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

// e
//   e button
//
// button
//   released
//     img = btn-released
//   pressed
//     img = btn-pressed

