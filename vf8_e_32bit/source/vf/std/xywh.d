module vf.std.xywh;

struct
XY {
union {
    ushort a;
struct {
    uint x;
    uint y;
}
}
    this (uint x, uint y) {
        this.x = x;
        this.y = y;
    }
}

struct
WH {
union {
    ushort a;
struct {
    uint w;
    uint h;
}
struct {
    uint x;
    uint y;
}
}
    void opAssign (uint b) { a = b &0xFFFF; }
}

struct
XYWH {
union {
    uint a;
struct {
    XY xy;
    WH wh;
}
struct {
    uint x;
    uint y;
    uint w;
    uint h;
}
}

    bool
    has (XY xy) {
        if (this.x <= xy.x)
        if (this.y <= xy.y)
        if (xy.x < this.x + this.w)
        if (xy.y < this.y + this.h)
            return true;
        return false;
    }

    string
    toString () {
        import std.format;
        return format!"XYWH(%3d,%3d %3d x%3d)" (x,y,w,h);
    }
}
