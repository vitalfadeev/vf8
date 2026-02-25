module mod.widget;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import mod.widget_button;
import mod.volume;


struct
Mod_widget {
    void
    do_switch (Event* evt) {
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_MOUSEBUTTONDOWN : _do_sdl_button (evt); break;
            case SDL_MOUSEBUTTONUP   : _do_sdl_button (evt); break;
            default                  :
        }
    }

    void
    _do_sdl_button (Event* evt) {
        import vf.sdl.importc_sdl;

        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button) {
            auto xy = XY (x,y);
            // widgets at xy
            foreach (i,xywh; page.layout.select (xy)) {
                evt.i    = i;
                evt.xywh = xywh;
                evt.e    = &page.es[i];
                page.widgets.do_widget_switch (evt);
                
                send (REDRAW, windowID, null, xywh);
            }
        }
    }
}
