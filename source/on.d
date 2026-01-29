module on;

struct
On (Event) {
    Rec[] recs;

    void
    go (O,E) (Event.Type type, O o, E e) {
        auto rec = select (type);
        if (rec !is null) {
            if (rec.new_event.type)
                o.send (&rec.new_event);
            if (rec.fn !is null)
                rec.fn (&rec.new_event, rec.data, cast (void*) o, cast (void*) e);
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
    opCall (Event.Type event_type, Event* new_event, FN fn=null, void* data=null) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec = Rec (event_type,*new_event,fn,data);
        else
            recs ~= Rec (event_type,*new_event,fn,data);
    }

    void
    opCall (Event.Type event_type, Event new_event, FN fn=null, void* data=null) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec  = Rec (event_type,new_event,fn,data);
        else
            recs ~= Rec (event_type,new_event,fn,data);
    }

    void
    opCall (Event.Type event_type, FN fn, void* data=null) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec  = Rec (event_type,Event (),fn,data);
        else
            recs ~= Rec (event_type,Event (),fn,data);
    }

    struct
    Rec {
        Event.Type event_type;
        Event      new_event;
        FN         fn;
        void*      data;
    }

    alias FN = void function (Event* evt, void* data, void* o, void* e);
}
