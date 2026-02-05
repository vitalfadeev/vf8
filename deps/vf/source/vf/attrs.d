module vf.attrs;

import vf.layout : Layout_Type=Type;


mixin template 
Attrs () {
    import vf.layout  : Layout_Type=Type;

    A[Aid.max+1] attrs;

    void x  (A   a) { attrs[Aid.x] = a; }
    void x  (int a) { attrs[Aid.x] = A.Int (a); }
    void y  (A   a) { attrs[Aid.y] = a; }
    void y  (int a) { attrs[Aid.y] = A.Int (a); }
    void w  (A   a) { attrs[Aid.w] = a; }
    void w  (int a) { attrs[Aid.w] = A.Int (a); }
    void w  (A.Perc a) { attrs[Aid.w] = a; }
    void w  (A.Parent_h a) { attrs[Aid.w] = a; }
    void h  (A   a) { attrs[Aid.h] = a; }
    void h  (int a) { attrs[Aid.h] = A.Int (a); }
    void h  (A.Parent_h a) { attrs[Aid.h] = a; }
    void childs_layout (A   a) { attrs[Aid.l] = a; }
    void childs_layout (Layout_Type a) { attrs[Aid.l] = A.Layout(a); }
    void fg (A    a) { attrs[Aid.fg] = a; }
    void fg (uint a) { attrs[Aid.fg] = A.UInt (a); }
    void bg (A    a) { attrs[Aid.bg] = a; }
    void bg (uint a) { attrs[Aid.bg] = A.UInt (a); }
    void type (uint  a) { attrs[Aid.tp] = A.EType (a); }
    void hotkey (string a) { attrs[Aid.hk] = A.Hotkey (a); }
    void img  (string a) { attrs[Aid.img] = A.Image (a); }
    void text (string a) { attrs[Aid.txt] = A.Text (a); }

    A x      () { return attrs[Aid.x]; }
    A y      () { return attrs[Aid.y]; }
    A w      () { return attrs[Aid.w]; }
    A h      () { return attrs[Aid.h]; }
    A fg     () { return attrs[Aid.fg]; }
    A bg     () { return attrs[Aid.bg]; }
    A type   () { return attrs[Aid.tp]; }
    A hotkey () { return attrs[Aid.hk]; }
    A img    () { return attrs[Aid.img]; }
    A text   () { return attrs[Aid.txt]; }

    auto
    calculated () {
        alias T = typeof(this);
        static if (__traits (hasMember, T, "Type"))
            return Calculated!T (this);
    }
}

enum 
Aid {
    _,
    x,
    y,
    w,
    h,
    l,    // childs_layout
    fg,   // fg
    bg,   // bg
    tp,   // type  // BUTTON
    hk,   // type  // BUTTON
    img,
    txt,
}

struct
A {
    Type type;
    union {
        Int      _int;
        UInt     _uint;
        Perc     _perc;
        Left     _left;
        Center   _center;
        Right    _right;
        Parent_w _parent_w;
        Parent_h _parent_h;
        Layout   _layout;
        EType    _etype;
        Hotkey   _hotkey;
        Image    _image;
        Text     _text;
    }

    enum
    Type {
        _,
        // Coord
        _int,
        _uint,
        _perc,
        _left,
        _center,
        _right,
        _parent_h,
        _parent_w,
        // Layout
        _layout,
        // E Type
        _etype,
        // hotkey
        _hotkey,
        _image,
        _text,
    }

    //
    struct
    Int {
        int a;
    }

    struct
    UInt {
        uint a;
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

    struct
    Layout {
        Layout_Type a;
    }        

    struct
    EType {
        uint  a;
    }        

    struct
    Hotkey {
        string a;
    }

    struct
    Image {
        string a;
    }

    struct
    Text {
        string a;
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
    opAssign (UInt b) {
        type = Type._uint;
        _uint = b;
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
    void
    opAssign (EType b) {
        type = Type._etype;
        _etype = b;
    }
    void
    opAssign (Hotkey b) {
        type = Type._hotkey;
        _hotkey = b;
    }
    void
    opAssign (Image b) {
        type = Type._image;
        _image = b;
    }
    void
    opAssign (Text b) {
        type = Type._text;
        _text = b;
    }
}

auto
perc (int a) {
    return A.Perc (a);
}    

static left     = A.Left ();
static center   = A.Center ();
static right    = A.Right ();
static parent_h = A.Parent_h ();

struct
Calculated (E) {
    E _this;

    uint
    bg () {
        switch (_this.bg.type) with (A.Type) {
            case _uint: return _this.bg._uint.a;
            default: return 0xFF000000;
        }
    }

    uint
    fg () {
        switch (_this.fg.type) with (A.Type) {
            case _uint: return _this.fg._uint.a;
            default: return 0xFFFFFFFF;
        }
    }

    uint 
    type () {
        switch (_this.type.type) with (A.Type) {
            case _etype: return _this.type._etype.a;
            default: return E.Type._;
        }
    }
}
