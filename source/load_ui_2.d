module load_ui_2;

import std.stdio : writeln;
import vf.e_class;
import vf.event;
import vf.attrs;
import vf.klass;
import vf.layout;
import vf.o : O;
import importc;


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
    e .window
        .e .page
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent
            .e .icon .data
                .e .image .parent
                .e .text  .parent.parent.parent
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
    on (Event.Type type, uint code, uint modifiers, Event new_event) {
        _e.on (type,code,modifiers,new_event);
        return this;
    }
    auto
    on (Event.Type type, string new_klass) {
        _e.on (type,new_klass);
        return this;
    }
    auto
    on (Event.Type type, uint code, uint modifiers, string new_klass) {
        _e.on (type,code,modifiers,new_klass);
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

    with (o.new_klass ("page")) {
        import vf.layout : Layout_Type=Type;
        childs_layout = Layout_Type.left_aligned_stacked_to_right;
    }

    with (o.new_klass ("icon")) {
        //
    }

    with (o.new_klass ("image")) {
        //
    }

    with (o.new_klass ("text")) {
        //
    }

    // mapper
    with (o.new_klass ("data")) {
        data_mapper = (Klass k, Event* evt, E e, void* _data) {
            auto data = cast (Data*) _data;
            e.childs[0].img  = data.img;
            e.childs[1].text = data.text;
        };
    }
}

struct
Data {
    string img;
    string text;
}

struct
Data_range (Data) {
    import std.range;
    Data[] s;
    Data*  front () { return &s[0]; };
    bool   empty () { return s.length == 0; }
    void   popFront () { s = s[1..$]; }
}

void
dump_klasses (O) (O o) {
    foreach (k; o.klasses) {
        writeln (k);
    }
}
