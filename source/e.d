module e;

auto
test () {
    return
    e .panel .window .canvas
    .e .loc1
     .e .button ._1
     .e .button ._2
     .e .button ._3
    .e .loc2
     .e .button .clock
    .e .loc3
     .e .indicator ._1
     .e .indicator ._2
     .e .indicator ._3
    ;
}

void
test_klass () {
    window
    .x (0)
    .y ("top")
    .w ("screen.w")
    .h (64)
    ;
}

alias 
GO = void function (void* o, void* e, void* evt, REG d);

alias
REG = void*;

struct
E {
    GO     go;
    float  x,y,w,h;
    E* l;
    E* r;
    E* cl;
    E* cr;
    E* parent;
    ubyte  bg_r;
    ubyte  bg_g;
    ubyte  bg_b;
    ubyte  bg_a;
    int    on_click_send_evt_code;  // PLAY_1

    E*
    add_klass (Klass* klass) {
        return &this;
    }

    E*
    add_child (E* e) {
        return &this;
    }
}

struct
Klass {
    Value[Properties.max+1] props;

    Klass*
    x (int a) {
        props[Properties.x] = Value (0,a);
        return &this;
    }

    Klass*
    y (int a) {
        props[Properties.y] = Value (0,a);
        return &this;
    }
    Klass*
    y (string a) {
        return &this;
    }

    Klass*
    w (int a) {
        props[Properties.w] = Value (0,a);
        return &this;
    }
    Klass*
    w (string a) {
        return &this;
    }

    Klass*
    h (int a) {
        props[Properties.h] = Value (0,a);
        return &this;
    }
}

enum
Properties {
    x,
    y,
    w,
    h,
}

struct
Value {
    uint type;
    int  value;
}

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

Klass panel_klass;
E*
panel (E* e) {
    e.add_klass (&panel_klass);
    return e;
}

Klass window_klass;
E*
window (E* e) {
    e.add_klass (&window_klass);
    return e;
}
Klass*
window () {
    return &window_klass;
}

Klass canvas_klass;
E*
canvas (E* e) {
    e.add_klass (&canvas_klass);
    return e;
}

Klass loc1_klass;
E*
loc1 (E* e) {
    e.add_klass (&loc1_klass);
    return e;
}

Klass loc2_klass;
E*
loc2 (E* e) {
    e.add_klass (&loc2_klass);
    return e;
}

Klass loc3_klass;
E*
loc3 (E* e) {
    e.add_klass (&loc3_klass);
    return e;
}

Klass button_klass;
E*
button (E* e) {
    e.add_klass (&button_klass);
    return e;
}

Klass _1_klass;
E*
_1 (E* e) {
    e.add_klass (&_1_klass);
    return e;
}

Klass _2_klass;
E*
_2 (E* e) {
    e.add_klass (&_2_klass);
    return e;
}

Klass _3_klass;
E*
_3 (E* e) {
    e.add_klass (&_3_klass);
    return e;
}

Klass clock_klass;
E*
clock (E* e) {
    e.add_klass (&clock_klass);
    return e;
}

Klass indicator_klass;
E*
indicator (E* e) {
    e.add_klass (&indicator_klass);
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
