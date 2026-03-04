module mod.draw;

import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl;
import vf.sdl.wm : Wm;
import std.stdio : writeln;

struct
Mod_draw (O) {
    O* o;

    void
    INIT () {
        //
    }

    void
    DRAW (uint windowID, Renderer* renderer) {
        import std.range : lockstep;

        renderer.fonts = &o.page.fonts;

        // all widgets
        foreach (widget,xywh; lockstep (o.page.widgets.s, o.page.layout.range)) {
            widget.DRAW (renderer, xywh);  // DRAW
        }
    }

    version (SDL) 
    void
    REDRAW (uint windowID, XYWH xywh) {
        //Wm (o). DRAW (windowID);
        writeln ("do REDRAW");
    }
}
