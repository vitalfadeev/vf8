module vf.base.send;



mixin template 
Send (Event) {  // if (is (Event==struct) && is(Event.Type == enum))
    void
    send_now (const Event.Type type){
        Event evt;
        evt.type = type;
        evt.o    = &this;
        if (do_switch !is null) do_switch (&evt);
    }
    import vf.sdl.renderer_sdl : Renderer;
    void
    send_now (const Event.Type type, uint windowID, Renderer* renderer) {
        Event evt;
        switch (type) with (Event.Type) {
            case DRAW   : evt.draw   = typeof(evt.draw)   (type,windowID,renderer); break;
            default     : assert (0);
        }
        evt.type = type;
        evt.o    = &this;
        if (do_switch !is null) do_switch (&evt);
    }

    void
    send (const Event.Type type) {
        Event evt;
        evt.type = type;
        evt.o    = &this;
        input ~= &evt;
    }
    import vf.sdl.renderer_sdl : Renderer;
    void
    send (const Event.Type type, uint windowID, Renderer* renderer, Xywh xywh) {
        Event evt;
        switch (type) with (Event.Type) {
            case DRAW        : evt.draw   = typeof(evt.draw)   (type,windowID,renderer,xywh); break;
            default          : assert (0);
        }
        evt.type = type;
        evt.o    = &this;
        input ~= &evt;
    }
    void
    send (const Event.Type type, uint windowID, Xywh xywh) {
        Event evt;
        switch (type) with (Event.Type) {
            case REDRAW      : evt.redraw = typeof(evt.redraw) (type,windowID,xywh); break;
            default          : assert (0);
        }
        evt.type = type;
        evt.o    = &this;
        input ~= &evt;
    }
    void
    send (const Event.Type type, string saction) {
        Event evt;
        switch (type) with (Event.Type) {
            case ACTION : evt.action = typeof(evt.action) (type,saction); break;
            default     : assert (0);
        }
        evt.type = type;
        evt.o    = &this;
        input ~= &evt;
    }
    void
    send (const Event.Type type, ubyte volume) {
        Event evt;
        switch (type) with (Event.Type) {
            case VOLUME_INFO : evt.volume = typeof(evt.volume) (type,volume); break;
            default     : assert (0);
        }
        evt.type = type;
        evt.o    = &this;
        input ~= &evt;
    }
}

