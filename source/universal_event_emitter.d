module universal_event_emitter;

struct
Universal_event_emitter (Event) {
    Rec[] recs;

    //void
    //go (Event* evt) {
    //    auto rec = select (evt);
    //    if (rec !is null) {
    //        Event event;
    //        event.type = rec.new_event;
    //        event.click.id = new_event_arg;
    //        send (&event);
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
    on (Event.Type event_type, Event* new_event) {
        recs ~= Rec (event_type,*new_event);
    }

    void
    on (Event.Type event_type, Event new_event) {
        recs ~= Rec (event_type,new_event);
    }

    struct
    Rec {
        Event.Type event_type;
        Event      new_event;
    }

    //alias FN = void function (Event* evt, void* data);
}
