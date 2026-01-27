module e_class;

import std.stdio  : writefln;
import std.stdio  : writeln;
import std.format : format;
import childs_parent;
import layout;
import event;

void
mai (T) () {
    O o = new O ();
    o.e = load_ui ();

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
load_ui () {
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
    void go (E_ui e, Event* evt);
}

class
E : GO {
    void 
    go (E_ui e, Event* evt) {
        //
    }
}

class
Ex : E {
    Ex    next_ex;
    void* data1;

    override
    void  
    go (E_ui e, Event* evt) {
        // ...
        with (evt.Type)
        switch (evt.type) {
            case UPDATE      : _update     (e,evt); break;
            case SET_E_PROP  : _set_e_prop (e,evt); break;
            case UPDATE_XY   : _update_xy  (e,evt); break;
            case DRAW        : _draw       (e,evt); break;
            default:
        }

        // next
        if (next_ex !is null) {
            next_ex.go (e,evt);
        }
    }

    void  
    _update (E_ui e, Event* evt) {
        //with (o)
        with (e) {
            // ...
        }
    }

    void  
    _set_e_prop (E_ui e, Event* evt) {
        //with (o)
        with (e)
        with (evt.set_e_prop) {
            // ...
        }
    }

    void  
    _update_xy (E_ui e, Event* evt) {
        //with (o)
        with (e) 
        with (evt.update_xy) {
            // ...
        }
    }

    void  
    _draw (E_ui e, Event* evt) {
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
}

class
E_ui : Ex {
    mixin Event_update_xy.tpl;
    mixin Event_draw.tpl;
    mixin Event_click.tpl;
    mixin Childs_parent!(typeof(this));

    override
    void 
    go (E_ui e, Event* evt) {
        writefln ("Event: %s", *evt);
        // ...

        // next
        super.go (e,evt);

        // childs
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP :
                with (evt.set_e_prop)
                foreach (_e; childs) _e.go (_e,evt);
                break;
            case UPDATE_XY :
                writefln ("%s: %s", this, childs_layout.a);
                with (evt.update_xy)
                if (has_childs) go_layout (e,evt);
                foreach (_e; childs) _e.go (_e,evt);
                break;
            default: /*each (o,e,evt);*/
        }
    }

    override
    void  
    _draw (E_ui e, Event* evt) {
        //with (o)
        with (e)
        with (evt.draw) {
            draw_rect (canvas,xy,wh,fg);
            draw_text (canvas,xy,wh,text);
            foreach (_e; childs) _e.go (_e,evt);
        }
    }

    void
    each (E e, Event* evt) {
        foreach (_e; childs)
            _e.go (_e,evt);
    }

    alias DGO = void delegate (E_ui e, Event* evt);

    override
    string
    toString () {
        string s;
        s = typeof(this).stringof ~ "(";
        for (auto _ex = next_ex; _ex !is null; _ex = _ex.next_ex) {
            s ~= " " ~ _ex.toString;
        }
        s ~= ")";
        return s;

    }
}

void
layout_fn () {
    // stacked.to_right__align_left
    // stacked.to_right__align_center
    // stacked.to_left
}


//void
//detect_strategy (O o, E_ui e, Event_update* evt) {
//    with (evt) {
//        if (e.w.type == e.w.Type._parent_h)
//            strategy = Strategy.hw;

//        if (e.h.type == e.h.Type._parent_w)
//            strategy = Strategy.wh;
//    }
//}

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
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
            x = 0;
            y = 0;
            w = Desktop.w;
            h = 64;
        }
        with (e) {
           fg = 0xFF00FF00;
           //     aabbggrr
        }
    }
}
auto panel (E_ui e) { return e.add_ex (new Panel); }
class Panel  : Ex {
    override string toString () { return typeof(this).stringof; }    
}
auto canvas (E_ui e) { return e.add_ex (new Canvas); }
class Canvas : Ex {
    override string toString () { return typeof(this).stringof; }
}
auto loc1 (E_ui e) { return e.add_ex (new Loc1); }
class 
Loc1 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {        
        with (e) with (Coord) {
           w = 33.perc;
           h = parent_h;
        }
        with (e) {
           //childs_layout = left_aligned.stacked.to_right;
           childs_layout = A.left_aligned_stacked_to_right;
        }
        with (e) {
           fg = 0x88444444;
        }
    }
}
auto button (E_ui e) { return e.add_ex (new Button); }
class Button : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
           w = Coord.parent_h;
        }
        with (e) {
           fg = 0xFFFF0000;
        }
    }    
}
auto _1 (E_ui e) { return e.add_ex (new __1); }
class __1 : Ex {
    override string toString () { return typeof(this).stringof; }
}
auto _2 (E_ui e) { return e.add_ex (new __2); }
class __2 : Ex {
    override string toString () { return typeof(this).stringof; }    
}
auto _3 (E_ui e) { return e.add_ex (new __3); }
class __3 : Ex {
    override string toString () { return typeof(this).stringof; }    
}
auto loc2 (E_ui e) { return e.add_ex (new Loc2); }
class 
Loc2 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
            w = 34.perc;
            h = Coord.parent_h;
        }
        with (e) {
           //childs_layout = center_aligned.stacked.to_right;
           childs_layout = A.center_aligned_stacked_to_right;
        }
        with (e) {
            fg = 0x88444444;
        }
    }
}
auto clock (E_ui e) { return e.add_ex (new Clock); }
class 
Clock : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
            w = 33.perc;
            h = Coord.parent_h;
        }
        with (e) {
            fg = 0xFFFFFF00;
        }
    }
}
auto loc3 (E_ui e) { return e.add_ex (new Loc3); }
class 
Loc3 : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
            w = 33.perc;
            h = Coord.parent_h;
        }
        with (e) {
            //childs_layout = right_aligned.stacked.to_left;
            childs_layout = A.right_aligned_stacked_to_left;
        }
        with (e) {
            fg = 0x88444444;
        }
    }
}
auto indicator (E_ui e) { return e.add_ex (new Indicator); }
class Indicator : Ex {
    override string toString () { return typeof(this).stringof; }

    override
    void  
    _set_e_prop (E_ui e, Event* evt) {
        with (e) {
            w = Coord.parent_h;
            h = Coord.parent_h;
        }
        with (e) {
           fg = 0xFF0000FF;
        }
    }
}

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

    if (e is null) return;

    // e
    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    // klasses
    for (auto ex = e.next_ex; ex !is null; ex = ex.next_ex) printf (" %x", ex);
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





version (NEVER)://
//struct
//_Event {
//union {
//    Type type;
//    Event_click      click;
//    Event_update     update;
//    Event_set_e_prop set_e_prop;
//    Event_update_w   update_w;
//    Event_update_h   update_h;
//    Event_update_xy  update_xy;
//    Event_draw       draw;
//}

//    enum
//    Type {
//        CLICK      =  1,
//        UPDATE,
//        SET_E_PROP = 11,
//        UPDATE_W,
//        UPDATE_H,
//        UPDATE_XY,
//        DRAW,
//    }

//    string
//    toString () {
//        return format!"Event(%s)" (type);
//    }
//}


//struct
//Event_click {
//    auto type = Event.Type.CLICK;

//    template
//    tpl () {
//        Event.Type on_click_send_evt_code;  // PLLAY_1
//    }
//}

//struct
//Event_update {
//    auto type     = Event.Type.UPDATE;
//    auto strategy = Strategy._;

//    enum
//    Strategy {
//        _,
//        wh,
//        hw,
//    }
//}

//struct
//Event_set_e_prop {
//    auto type = Event.Type.SET_E_PROP;
//}

//struct
//Event_update_w {
//    auto type = Event.Type.UPDATE_W;
//}

//struct
//Event_update_h {
//    auto type = Event.Type.UPDATE_H;
//}

//struct
//Event_update_xy {
//    auto  type = Event.Type.UPDATE_XY;
//    // left
//    float line_height = 64.0;
//    Cursor[] cursors;
//    auto ref cursor () { import std.range : back; return cursors.back; }  // current cursor
//    struct
//    Cursor {
//        float x = 0;         // start location
//        float y = 0;         // 
//        float start_x = 0;   // area xy
//        float start_y = 0;   //
//        float limit_x = 0;   // area (wh from parent + vars)
//        float limit_y = 0;   // 
//        float total_w = 0;
//        float total_h = 0;
//    }

//    void
//    inc_cursor () {
//        cursors.length += 1;
//        cursor = Cursor ();  // init
//    }

//    void
//    dec_cursor () {
//        cursors.length -= 1;
//    }

//    template
//    tpl () {
//        mixin Xywh!E_ui;
//        mixin Layout!E_ui;        
//    }
//}

//struct
//Event_draw {
//    auto  type = Event.Type.DRAW;

//    import importc;
//    Tvg_Canvas  canvas;

//    void
//    draw_rect (Tvg_Canvas canvas, XY xy, XY wh) {
//        ubyte bg_r, bg_g, bg_b, bg_a;
//        bg_r = bg_g = bg_b = bg_a = 255;
//        Tvg_Paint shape = tvg_shape_new ();
//        //tvg_shape_append_rect (shape, x, y, w, h, 0.0f, 0.0f, true);
//        tvg_shape_append_rect (shape, xy.x, xy.y, wh.w, wh.h, 0.0f, 0.0f, true);
//        tvg_shape_set_fill_color (shape, bg_r, bg_g, bg_b, bg_a);

//        //Push the shape into the canvas
//        tvg_canvas_push (canvas, shape);
//    }

//    void
//    draw_text (Tvg_Canvas canvas, XY xy, XY wh, string text) {
//        {
//            //import importc;

//            //auto canvas = cast (Tvg_Canvas) d;

//            ////
//            //if (tvg_font_load (font_file.ptr) != TVG_RESULT_SUCCESS) {
//            //    printf ("Problem with loading the font from the file. Did you enable TTF Loader?\n");
//            //}

//            //Tvg_Paint _text = tvg_text_new ();
//            //tvg_text_set_font   (_text, font_name.ptr);
//            //tvg_text_set_size   (_text, font_size);
//            //tvg_text_set_color  (_text, font_color_r, font_color_g, font_color_b);
//            //tvg_text_set_text   (_text, text.ptr);
//            //tvg_paint_translate (_text, x, y);
//            //tvg_canvas_push (canvas, _text);
//        }
//    }

//    template
//    tpl () {
//        Color  bg;
//        Color  fg;
//        string text;
//    }
//}

//class
//O {
//    E_ui e;

//    void 
//    go (Event* evt) {
//        e.go (this,e,evt);
//    }
//}

//struct
//Canvased {
//    Coord x,y,w,h;
//    Color color;

//    alias Coord = float;
//}
//alias Color = uint;


//struct
//Get_width {
//    FN _get_width = &fixed;

//    alias FN = void function ();

//    void
//    opAssign (FN b) {
//        _get_width = b;
//    }

//    void
//    opCall () {
//        _get_width ();
//    }

//    static
//    void
//    fixed () {
//        //
//    }

//    static
//    void
//    by_content () {
//        //
//    }
//}



//// e
////   e
////
//// klass
////   x = left stack
////   w = parent
////
////   x = left stack
////   x = center stack
////   x = right stack



//struct
//Universal_emitter {
//    Rec* a;
//    Rec* z;

//    alias Type = typeof (Event.type);
//    alias CB   = void function (O o, E_ui e, Event* evt);

//    void
//    check_and_emit (O o, E_ui e, Event* evt) {
//        for (auto rec=a; rec !is null; rec = rec.next) {
//            if (rec.type == evt.type) {
//                rec.cb (o,e,evt);
//            }
//        }
//    }

//    void
//    connect (Type type, CB cb) {
//        auto rec = new Rec (type,cb);

//        if (z is null) {
//            z = rec;
//            a = rec;
//        }
//        else {
//            rec.prev = z;
//            z.next = rec;
//            z = rec;
//        }
//    }

//    struct
//    Rec {
//        Type type;
//        CB   cb;   // DList!CB
//        Rec* prev;
//        Rec* next;
//    }
//}
