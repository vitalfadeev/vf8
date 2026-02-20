module vf.base.send;


mixin template 
Send (Event) {  // if (is (Event==struct) && is(Event.Type == enum))
    void
    send_now (Event.Type type) {
        Event evt;
        evt.type = type;
        evt.o = this.o;
        do_switch (&evt);
    }
    void
    send_now (Event* evt) {
        do_switch (evt);
    }
    void
    send_now (Event evt) {
        evt.o = this.o;
        do_switch (&evt);
    }

    void
    send (Event.Type type) {
        Event evt;
        evt.type = type;
        evt.o = this.o;
        o.input ~= &evt;
    }   
    void
    send (Event* evt) {
        evt.o = this.o;
        o.input ~= evt;
    }   
}
