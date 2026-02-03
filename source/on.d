module on;


mixin template 
On (Event) {
    _On!Event _on;

    auto
    on (Event.Type type, _On!Event.DG dg) {
        _on.add (type,dg);
        return this;
    }
}

struct
_On (Event) {
    Rec[] recs;

    void
    go (E) (Event* evt, E e) {
        auto rec = select (evt.type);
        if (rec !is null) {
            if (rec.dg !is null)
                rec.dg (evt);
        }
    }

    auto
    select (Event.Type type) {
        foreach (ref rec; recs) {
            if (rec.event_type == type) {
                return &rec;
            }
        }

        return null;
    }

    void
    add (Event.Type event_type, DG dg, void* data=null) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec  = Rec (event_type,dg,data);
        else
            recs ~= Rec (event_type,dg,data);
    }

    struct
    Rec {
        Event.Type event_type;
        DG         dg;
        void*      data;
    }

    alias FN = void function (Event* evt, void* data, void* e, void* o);
    alias DG = void delegate (Event* evt);
}
