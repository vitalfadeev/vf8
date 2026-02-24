module mod.draw;

import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl;
import vf.sdl.wm : Wm;

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
            import vf.gui.color  : Color;

            renderer.fonts = &page.fonts;
            ubyte i;

            foreach (e,xywh; lockstep (page.es.range, page.layout.range)) {
                evt.i    = i;
                evt.xywh = xywh;
                evt.e    = &page.es[i];
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
            Wm (). _send_draw (evt,windowID);
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
            version (SDL) 
            uint        windowID;
            Renderer*   renderer;
            XYWH        xywh;
        }

        struct
        Redraw {
            Type type = Type.REDRAW;
            version (SDL) import vf.sdl.renderer_sdl : Renderer;
            version (SDL) 
            uint        windowID;
            Renderer*   renderer;
            XYWH        xywh;
        }
    }
}
