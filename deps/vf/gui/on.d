module vf.gui.on;


mixin template 
On (Event_type) {
    alias DG = void delegate ();
    
    _On!Event_type _on;

    auto
    on (Event_type type, DG dg) {
        _on.add (type,dg);
        return this;
    }
    auto
    on (Event_type type, uint code, uint modifiers, DG dg) {
        _on.add (type,code,modifiers,dg);
        return this;
    }
    //auto
    //on (Event.Type type, Event new_event) {
    //    _on.add (type,new_event);
    //    return this;
    //}
    //auto
    //on (Event.Type type, uint code, uint modifiers, Event new_event) {
    //    _on.add (type,code,modifiers,new_event);
    //    return this;
    //}
    //auto
    //on (Event.Type type, string klass_name) {
    //    _on.add (type,klass_name);
    //    return this;
    //}
    //auto
    //on (Event.Type type, uint code, uint modifiers, string klass_name) {
    //    _on.add (type,code,modifiers,klass_name);
    //    return this;
    //}
}

struct
_On (Event_type) {
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
    select (Event_type type, uint code = 0, uint modifiers = 0) {
        foreach (ref rec; recs) {
            if (rec.event_type == type && rec.code == code && (rec.modifiers == modifiers)) {
                return &rec;
            }
        }

        return null;
    }

    void
    add (Event_type event_type, DG dg) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec  = Rec (event_type,0,0,dg);
        else
            recs ~= Rec (event_type,0,0,dg);
    }
    void
    add (Event_type event_type, uint code, uint modifiers, DG dg) {
        auto rec = select (event_type);
        if (rec !is null)
            *rec  = Rec (event_type,code,modifiers,dg);
        else
            recs ~= Rec (event_type,code,modifiers,dg);
    }

    //void
    //add (Event.Type event_type, ref Event new_event) {
    //    auto rec = select (event_type);
    //    if (rec !is null)
    //        *rec  = Rec (event_type,0,0,null,null,new_event);
    //    else
    //        recs ~= Rec (event_type,0,0,null,null,new_event);
    //}

    //void
    //add (Event.Type event_type, uint code, uint modifiers, ref Event new_event) {
    //    auto rec = select (event_type);
    //    if (rec !is null)
    //        *rec  = Rec (event_type,code,modifiers,null,null,new_event);
    //    else
    //        recs ~= Rec (event_type,code,modifiers,null,null,new_event);
    //}

    //void
    //add (Event.Type event_type, string klass_name) {
    //    auto rec = select (event_type);
    //    if (rec !is null)
    //        *rec  = Rec (event_type,0,0,null,null,Event(),klass_name);
    //    else
    //        recs ~= Rec (event_type,0,0,null,null,Event(),klass_name);
    //}

    //void
    //add (Event.Type event_type, uint code, uint modifiers, string klass_name) {
    //    auto rec = select (event_type,code,modifiers);
    //    if (rec !is null)
    //        *rec  = Rec (event_type,code,modifiers,null,null,Event(),klass_name);
    //    else
    //        recs ~= Rec (event_type,code,modifiers,null,null,Event(),klass_name);
    //}

    struct
    Rec {
        Event_type event_type;
        uint       code;
        uint       modifiers;
        DG         dg;
        void*      data;
        //Event      new_event;
        string     klass;
    }

    //alias FN = void function (Event* evt, void* data, void* e, void* o);
    alias DG = void delegate ();
}
