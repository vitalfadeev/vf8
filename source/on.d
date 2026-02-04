module on;


mixin template 
On (Event) {
    _On!Event _on;

    auto
    on (Event.Type type, _On!Event.DG dg) {
        _on.add (type,dg);
        return this;
    }
    auto
    on (Event.Type type, Event new_event) {
        _on.add (type,new_event);
        return this;
    }
    auto
    on (Event.Type type, string klass_name) {
        _on.add (type,klass_name);
        return this;
    }
}

struct
_On (Event) {
    Rec[] recs;

    //void
    //go (E) (Event* evt, E e) {
    //    auto rec = select (evt.type);
    //    if (rec !is null) {
    //        if (rec.dg !is null)
    //            rec.dg (evt);
    //    }
    //}

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

    void
    add (Event.Type event_type, ref Event new_event) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec  = Rec (event_type,null,null,new_event);
        else
            recs ~= Rec (event_type,null,null,new_event);
    }

    void
    add (Event.Type event_type, string klass_name) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec  = Rec (event_type,null,null,Event(),klass_name);
        else
            recs ~= Rec (event_type,null,null,Event(),klass_name);
    }

    struct
    Rec {
        Event.Type event_type;
        DG         dg;
        void*      data;
        Event      new_event;
        string     add_klass;
        string     rem_klass;
    }

    alias FN = void function (Event* evt, void* data, void* e, void* o);
    alias DG = void delegate (Event* evt);
}
