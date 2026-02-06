module vf.base.event;

struct
Event {
union {
    Type  type;
    Base _base;
}

    enum
    Type {
        _,
        OPEN,
        DO_1,
        DO_FORCED,
        CLOSE,
        QUIT,
    }

    string
    toString () {
        import std.format : format;
        return format!"%s(%s)" (typeof(this).stringof, type);
    }
}

struct
Base {
    Event.Type type = Event.Type._;
}

