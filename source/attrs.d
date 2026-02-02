module attrs;


mixin template 
Attrs () {
    A[Aid.max+1] attrs;

    void x  (A   a) { attrs[Aid.x] = a; }
    void x  (int a) { attrs[Aid.x] = A.Int (a); }
    void y  (A   a) { attrs[Aid.y] = a; }
    void y  (int a) { attrs[Aid.y] = A.Int (a); }
    void w  (A   a) { attrs[Aid.w] = a; }
    void w  (int a) { attrs[Aid.w] = A.Int (a); }
    void w  (A.Perc a) { attrs[Aid.w] = a; }
    void w  (A.Parent_h a) { attrs[Aid.h] = a; }
    void h  (A   a) { attrs[Aid.h] = a; }
    void h  (int a) { attrs[Aid.h] = A.Int (a); }
    void h  (A.Parent_h a) { attrs[Aid.h] = a; }
    void childs_layout (A   a) { attrs[Aid.l] = a; }
    import layout : Layout_Type=Type;
    void childs_layout (Layout_Type a) { attrs[Aid.l] = A.Layout(a); }
    void fg (A    a) { attrs[Aid.f] = a; }
    void fg (uint a) { attrs[Aid.f] = A.Int (a); }
    void bg (A    a) { attrs[Aid.b] = a; }
    void bg (uint a) { attrs[Aid.b] = A.Int (a); }

    A x  () { return attrs[Aid.x]; }
    A y  () { return attrs[Aid.y]; }
    A w  () { return attrs[Aid.w]; }
    A h  () { return attrs[Aid.h]; }
    A fg () { return attrs[Aid.f]; }
    A bg () { return attrs[Aid.b]; }
}

enum 
Aid {
    _,
    x,
    y,
    w,
    h,
    l,  // childs_layout
    f,
    b,
}

struct
A {
    Type type;
    union {
        Int      _int;
        Perc     _perc;
        Left     _left;
        Center   _center;
        Right    _right;
        Parent_w _parent_w;
        Parent_h _parent_h;
        Layout   _layout;
    }

    enum
    Type {
        _,
        // Coord
        _int,
        _perc,
        _left,
        _center,
        _right,
        _parent_h,
        _parent_w,
        // Layout
        _layout,
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

    import layout : Layout_Type=Type;
    struct
    Layout {
        Layout_Type a;
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
    void
    opAssign (Layout b) {
        type = Type._layout;
        _layout = b;
    }

    static left     = Left ();
    static center   = Center ();
    static right    = Right ();
    static parent_h = Parent_h ();
}

auto
perc (int a) {
    return A.Perc (a);
}    

static left     = A.Left ();
static center   = A.Center ();
static right    = A.Right ();
static parent_h = A.Parent_h ();
