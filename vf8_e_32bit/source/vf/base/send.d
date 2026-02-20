module vf.base.send;


mixin template 
Send (Event) {  // if (is (Event==struct) && is(Event.Type == enum))
    void
    send_now (Event.Type type) {
        Event evt;
        evt.type = type;
        evt.o = &this;
        if (do_switch !is null) do_switch (&evt);
    }
    void
    send_now (Event* evt) {
        if (do_switch !is null) do_switch (evt);
    }
    void
    send_now (Event evt) {
        evt.o = &this;
        if (do_switch !is null) do_switch (&evt);
    }

    void
    send (Event.Type type) {
        Event evt;
        evt.type = type;
        evt.o = &this;
        input ~= &evt;
    }   
    void
    send (Event* evt) {
        evt.o = &this;
        input ~= evt;
    }   
}
