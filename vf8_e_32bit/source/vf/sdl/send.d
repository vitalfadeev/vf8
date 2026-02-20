module vf.sdl.send;


mixin template 
Send (Event) {  // if (is (Event==struct) && is(Event.Type == enum))
    version (SDL) import vf.sdl.renderer_sdl : Renderer;
    version (SDL) 
    void
    send_now (Event.Type type, Renderer* renderer) {
        Event evt;
        evt.type = type;
        switch (type) with (Event.Type) {
            case DRAW : evt.draw.renderer = renderer; break;
            default:
        }
        do_switch (&evt);
    }

    version (SDL) import vf.sdl.renderer_sdl : Renderer;
    version (SDL) 
    void
    send (Event.Type type, Renderer* renderer) {
        Event evt;
        evt.type = type;
        switch (type) with (Event.Type) {
            case DRAW : evt.draw.renderer = renderer; break;
            default:
        }
        o.input ~= &evt;
    }

    version (SDL) import vf.std.xywh : XYWH;
    version (SDL) 
    void
    send (Event.Type type, XYWH xywh) {
        Event evt;
        evt.type = type;
        switch (type) with (Event.Type) {
            case REDRAW : evt.redraw.xywh = xywh; break;
            default:
        }
        o.input ~= &evt;
    }
}
