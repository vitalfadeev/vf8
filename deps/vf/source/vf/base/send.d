module vf.base.send;


mixin template 
Send (Event) {  // if (is (Event==struct) && is(Event.Type == enum))
    void
    send_now (Event* evt)  {
        assert (go !is null);
        if (go !is null) 
            go (&this,evt);
    }

    void
    send_now (Event evt) {
        assert (go !is null);
        if (go !is null) 
            go (&this,&evt);
    }

    void
    send_now (Event.Type type) {
        assert (go !is null);
        Event event;
        event.type = type;
        if (go !is null) 
            go (&this,&event);
    }

    void
    send (Event* event) {
        _input ~= event;
    }

    void
    send (Event event) {
        _input ~= &event;
    }

    void
    send (Event.Type type) {
        Event event;
        event.type = type;
        _input ~= &event;
    }
}
