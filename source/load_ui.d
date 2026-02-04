module load_ui;

import e_class;
import event;
import attrs;
import klass;
import layout;
import importc;
import app : O=O3;
import std.stdio : writeln;


void
mai (T) () {
    O o = new O ();
    o.e = load_ui (o);

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



        // LAYOUT
        auto evt5 = Event (LAYOUT);
        evt5.layout.cursors.length = 1;
        o.go (&evt5);

        // ...
        //auto evt6 = Event (...);
        //o.go (&evt6);

        dump_tree (o.e);
    }
}

auto
load_ui (O) (O o) {
    load_klasses (o);
    dump_klasses (o);
    auto e = OE!O (o,new E());
    with (Event.Type)
    e .window .panel .canvas  // {o,e}
        .e .loc1
            .e .button ._1  
                //.on (PRESS,        &o._on_click_1)
                //.on (HOTKEY_PRESS, &o._on_click_1)
                .on (BUTTON_LEFT, Event (PLAY_1))
                .on (PLAY_1, Event (PRESS))
                .on (PRESS, "pressed")
                //.hotkey ("a")
                .parent
            .e .button ._2  
                .on (Event.Type.PRESS,        &o._on_click_2)
                .on (Event.Type.HOTKEY_PRESS, &o._on_click_2)
                .hotkey ("s")
                .parent
            .e .button ._3  
                .on (Event.Type.PRESS,        &o._on_click_3)
                .on (Event.Type.HOTKEY_PRESS, &o._on_click_3)
                .hotkey ("d")
                .parent.parent
        .e .loc2
            .e .button .clock  .parent.parent
        .e .loc3
            .e .indicator ._1  .parent
            .e .indicator ._2  .parent
            .e .indicator ._3  .parent.parent
     ;
    return e._e;
}

struct
OE (O) {
    O _o;
    E _e;

    auto 
    e () {
        return OE!O (_o, _e.add_child (new E ()));
    }
    auto
    e (OE _oe) {
        return OE!O (_o, _oe._e.add_child (new E ()));
    }
    auto
    parent () {
        return OE (_o,_e.parent);
    }

    auto
    on (DG) (Event.Type type, DG dg) {
        _e.on (type,dg);
        return this;
    }
    auto
    on (Event.Type type, Event new_event) {
        _e.on (type,new_event);
        return this;
    }
    auto
    on (Event.Type type, string new_klass) {
        _e.on (type,new_klass);
        return this;
    }

    auto
    hotkey (string s) {
        _e.hotkey = s;
        return this;
    }

    // window
    auto
    opDispatch (string name) () {
        auto k = _o.select_klass (name);
        _e.add_klass (k);
        return this;
    }
}


import std.algorithm; // для splitter
import std.range;     // для last

void
load_klasses (O o) {
    with (o.new_klass ("window")) {
        x  = 0;
        y  = 0;
        w  = Desktop.w;
        h  = 64;
        fg = 0xFF00FF00;
        //     aabbggrr
    }

    with (o.new_klass ("panel")) {
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.left_aligned_stacked_to_right;
    }

    with (o.new_klass ("canvas")) {
        //
    }

    with (o.new_klass ("loc1")) {
        w  = 33.perc;
        h  = parent_h;
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.left_aligned_stacked_to_right;
        fg = 0x88444444;
        //     aabbggrr
    }

    with (Event.Type)
    with (o.new_klass ("button")) {
        //type = E.Type.BUTTON;
        w    = parent_h;
        bg   = 0xFF003300;
        fg   = 0xFFFF0000;
        //       aabbggrr
        //on (CLICK, &o.on_click);
    }

    with (o.new_klass ("pressed")) {
        bg = 0xFFCCCCCC;
    }

    with (o.new_klass ("_1")) {
        //
    }

    with (o.new_klass ("_2")) {
        //
    }

    with (o.new_klass ("_3")) {
        //
    }

    with (o.new_klass ("loc2")) {
        w = 34.perc;
        h = parent_h;
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.center_aligned_stacked_to_right;
        fg = 0x88444444;
    }

    with (o.new_klass ("clock")) {
        w  = 33.perc;
        h  = parent_h;
        fg = 0xFFFFFFFF;
    }

    with (o.new_klass ("loc3")) {
        w  = 33.perc;
        h  = parent_h;
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.right_aligned_stacked_to_left;
        fg = 0x88444444;
    }

    with (o.new_klass ("indicator")) {
        w  = parent_h;
        h  = parent_h;
        fg = 0xFF0000FF;
    }
}

void
dump_klasses (O) (O o) {
    foreach (k; o.klasses) {
        writeln (k);
    }
}
