module layout.xywh;

import layout.xy;

alias W = X;
alias H = Y;


mixin template
Xywh (E) {
    Coord x,y,w,h;

    XY
    wh (this T) () {
        auto _wh = XY (_w (this), _h (this));
        return _wh;
    }
}

W  
_w (E) (E e) {
    with (e.w.type)
    switch (e.w.type) {
        case _parent_w : return e.parent.wh.w;
        case _parent_h : return e.parent.wh.h; 
        case _int      : return e.w._int.a; 
        case _perc     : return (cast (W) e.w._perc.a) * e.parent.wh.w / 100; 
        default        : return e.parent.wh.w;
    }
}

H  
_h (E) (E e) {
    with (e.h.type)
    switch (e.h.type) {
        case _parent_w : return e.parent.wh.w; 
        case _parent_h : return e.parent.wh.h;
        case _int      : return e.h._int.a; 
        case _perc     : return (cast (H) e.h._perc.a) * e.parent.wh.h / 100; 
        default        : return e.parent.wh.h;
    }
}


Coord a;

struct
Coord {
    Type     type;
union {
    Int      _int;
    Perc     _perc;
    Left     _left;
    Center   _center;
    Right    _right;
    Parent_w _parent_w;
    Parent_h _parent_h;
}

    void
    opAssign (int b) {
        type = Type._int;
        _int = Int (b);
    }
    void
    opAssign (Int b) {
        type = Type._int;
        _int = b;
    }
    void
    opAssign (Perc b) {
        type = Type._perc;
        _perc = b;
    }
    void
    opAssign (Left b) {
        type = Type._left;
        _left = b;
    }
    void
    opAssign (Center b) {
        type = Type._center;
        _center = b;
    }
    void
    opAssign (Right b) {
        type = Type._right;
        _right = b;
    }
    void
    opAssign (Parent_w b) {
        type = Type._parent_w;
        _parent_w = b;
    }
    void
    opAssign (Parent_h b) {
        type = Type._parent_h;
        _parent_h = b;
    }

    static left     = Left ();
    static center   = Center ();
    static right    = Right ();
    static parent_h = Parent_h ();

    enum
    Type {
        _,
        _int,
        _perc,
        _left,
        _center,
        _right,
        _parent_h,
        _parent_w,
    }

    //
    struct
    Int {
        int a;
    }

    struct
    Perc {
        int a;

        //auto 
        //opBinaryRight (string op : "*") (float rhs) {
        //    return a * rhs;
        //}
    }

    struct
    Left {
        int a;
    }

    struct
    Center {
        int a;
    }

    struct
    Right {
        int a;
    }

    struct
    Parent_h {
        int a;
    }

    struct
    Parent_w {
        int a;
    }
}

auto
perc (int a) {
    return Coord.Perc (a);
}
