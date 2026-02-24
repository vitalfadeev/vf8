module vf.sdl.send;


mixin template 
Send (Event) {  // if (is (Event==struct) && is(Event.Type == enum))
    version (SDL) import vf.sdl.renderer_sdl : Renderer;
    version (SDL) 
    void
    send_now (Event.Type type, uint windowID, Renderer* renderer) {
        Event evt;
        evt.type = type;
        evt.o = &this;
        switch (type) with (Event.Type) {
            case DRAW : 
                evt.draw.windowID = windowID; 
                evt.draw.renderer = renderer; 
                break;
            case REDRAW : 
                evt.redraw.windowID = windowID; 
                evt.redraw.renderer = renderer; 
                break;
            default:
        }
        do_switch (&evt);
    }

    version (SDL) import vf.sdl.renderer_sdl : Renderer;
    version (SDL) 
    void
    send (Event.Type type, uint windowID, Renderer* renderer) {
        Event evt;
        evt.type = type;
        evt.o = &this;
        switch (type) with (Event.Type) {
            case DRAW : 
                evt.draw.windowID = windowID; 
                evt.draw.renderer = renderer; 
                break;
            case REDRAW : 
                evt.redraw.windowID = windowID; 
                evt.redraw.renderer = renderer; 
                break;
            default:
        }
        input ~= &evt;
    }

    version (SDL) import vf.std.xywh : XYWH;
    version (SDL) 
    void
    send (Event.Type type, uint windowID, XYWH xywh) {
        Event evt;
        evt.type = type;
        evt.o = &this;
        switch (type) with (Event.Type) {
            case REDRAW : 
                evt.redraw.windowID = windowID; 
                evt.redraw.xywh     = xywh; 
                break;
            default:
        }
        input ~= &evt;
    }
}
