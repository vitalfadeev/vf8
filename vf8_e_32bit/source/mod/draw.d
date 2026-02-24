module mod.draw;

import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl;


struct
Mod_draw {
    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case INIT   : _init      (evt); break;
            case DRAW   : _do_draw   (evt); break;
            case REDRAW : _do_redraw (evt); break;
            default     :
        }
    }

    void
    _init (Event* evt) {
        //
    }

    void
    _do_draw (Event* evt) {
        with (evt.o)
        with (evt.draw) {
            import std.range     : lockstep;
            import vf.gui.colors : Color;

            renderer.fonts = &fonts;
            ubyte i;

            foreach (e,xywh; lockstep (page.es.range, page.layout.range)) {
                evt.i    = i;
                evt.xywh = xywh;
                do_widget_switch (evt);  // DRAW

                i++;
            }
        }
    }

    version (SDL) 
    void
    _do_redraw (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.redraw) {
            auto _window = wm.window.window;
            import vf.sdl.renderer_sdl : Renderer;
            Renderer renderer;
            renderer.draw_start (_window);
            send_now (DRAW,&renderer);
            renderer.draw_end (_window);
        }
    }

    struct
    _Event {
        Type type;

        union {
            Draw   draw;
            Redraw redraw;
        }

        enum
        Type {
            DRAW,
            DRAWED,
            DRAW_INFO,
            REDRAW,
        }

        struct
        Draw {
            Type  type = Type.DRAW;
            version (SDL) import vf.sdl.renderer_sdl : Renderer;
            version (SDL) import vf.sdl.window       : Window;
            version (SDL) Window*   window;
            Renderer*   renderer;
            XYWH        xywh;
        }

        struct
        Redraw {
            Type type = Type.REDRAW;
            XYWH xywh;
        }
    }
}
