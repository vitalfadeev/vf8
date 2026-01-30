module layout;

public import layout.stacked.to_right_down_left_aligned;
public import layout.stacked.to_right_down_center_aligned;
public import layout.stacked.to_left_down_right_aligned;
public import layout.xy;
public import layout.xywh;


mixin template
Layout (E) {
    // this
    XY xy;
    // for childs
    XY childs_space;
    Childs_layout!E childs_layout;

    void
    go_layout (Event* evt) {
        switch (childs_layout.a) with (A) {
            case _: 
                goto default;
                break;
            case left_aligned_stacked_to_right: 
                to_right_down_left_aligned (this);
                break;
            case center_aligned_stacked_to_right: 
                to_right_down_center_aligned (this);
                break;
            case right_aligned_stacked_to_left: 
                to_left_down_right_aligned (this);
                break;
            default:
                to_right_down_left_aligned (this);
        }        
    }

    A left_aligned   (A a = A._) { return a | A.left_aligned; }
    A center_aligned (A a = A._) { return a | A.center_aligned; }
    A right_aligned  (A a = A._) { return a | A.right_aligned; }
    A stacked        (A a = A._) { return a | A.stacked; }
    A to_right       (A a = A._) { return a | A.to_right; }
    A to_left        (A a = A._) { return a | A.to_left; }
}

struct
Childs_layout (E) {
    A a;

    alias FN = void function (E _this);

    // childs_layout = left_aligned.stacked.to_right;
    void
    opAssign (A b) {
        a = b;
    }
    bool
    opEquals (A b) {
        return (a == b);
    }
}

enum
A {
    _,
    left_aligned   = 0b0000_0001,
    right_aligned  = 0b0000_0010,
    center_aligned = 0b0000_0100,
    to_left        = 0b0001_0000,
    to_right       = 0b0010_0000,
    stacked        = 0b0100_0000,
    //
    left_aligned_stacked_to_right   = stacked | to_right  | left_aligned,
    center_aligned_stacked_to_right = stacked | to_right  | center_aligned,
    right_aligned_stacked_to_left   = stacked | to_left   | right_aligned,
}

void
ltor_dn_stacked_center () {
    //
}
void
ltor_dn_stacked_right () {
    //
}
void
rtol_dn_stacked_left () {
    //
}
void
rtol_dn_stacked_center () {
    //
}
void
rtol_dn_stacked_right () {
    //
}
void
ltor_up_stacked_left () {
    //
}
void
ltor_up_stacked_center () {
    //
}
void
ltor_up_stacked_right () {
    //
}
void
rtol_up_stacked_left () {
    //
}
void
rtol_up_stacked_center () {
    //
}
void
rtol_up_stacked_right () {
    //
}
void
flex () {
    //
}
