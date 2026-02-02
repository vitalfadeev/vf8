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
auto 
e () {
    return new E ();
}
auto
e (E _e) {
    return _e.add_child (new E ());
}
auto
parent (E e) {
    return e.parent;
}

auto window (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        x  = 0;
        y  = 0;
        w  = Desktop.w;
        h  = 64;
        fg = 0xFF00FF00;
        //     aabbggrr
        return e.add_klass (k);
    }
}
auto panel (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.left_aligned_stacked_to_right;
        return e.add_klass (k);
    }
}
auto canvas (E e) {
    auto k = new Klass (__FUNCTION__);
    with (k) {
        return e.add_klass (k);
    }
}
auto loc1 (E e) {
    auto k = new Klass (__FUNCTION__);
    with (k) {
        w  = 33.perc;
        h  = parent_h;
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.left_aligned_stacked_to_right;
        fg = 0x88444444;
        //     aabbggrr
        return e.add_klass (k);
    }
}
auto button (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        w  = parent_h;
        bg = 0xFF00FF00;
        fg = 0xFFFF0000;
        //     aabbggrr
        // on (CLICK, Event (), &on_click);
        return e.add_klass (k);
    }
}
auto pressed (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        bg = 0xFFCCCCCC;
        //     aabbggrr
        return e.add_klass (k);
    }
}
auto _1 (E e) {
    auto k = new Klass (__FUNCTION__);
    with (k) {
        // on (CLICK, Event (Event_play (PLAY,1)));
        return e.add_klass (k);
    }
}
auto _2 (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        //on (CLICK, Event (Event_play (PLAY,2)));
        return e.add_klass (k);
    }
}
auto _3 (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        // on (CLICK, Event (Event_play (PLAY,3)));
        return e.add_klass (k);
    }
}
auto loc2 (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        w = 34.perc;
        h = parent_h;
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.center_aligned_stacked_to_right;
        fg = 0x88444444;
        return e.add_klass (k);
    }
}
auto clock (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        w  = 33.perc;
        h  = parent_h;
        fg = 0xFFFFFFFF;
        //on_click_send_evt_type = Event.Type.PLAY;
        //on_click_send_evt_arg  = 1; // Arg (int,string)
        return e.add_klass (k);
    }
}
auto loc3 (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        w  = 33.perc;
        h  = parent_h;
        import layout : Layout_Type=Type;
        childs_layout = Layout_Type.right_aligned_stacked_to_left;
        fg = 0x88444444;
        return e.add_klass (k);
    }
}
auto indicator (E e) { 
    auto k = new Klass (__FUNCTION__);
    with (k) {
        w = parent_h;
        h = parent_h;
        fg = 0xFF0000FF;
        return e.add_klass (k);
    }
}
