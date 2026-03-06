module mod.widget.button;

version (SDL):
import mod.widget          : Widget;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.std.xywh         : Xywh;
import vf.std.xywh         : Xy;
import vf.gui.style        : Style;
import std.stdio : writeln;
import app : o;


struct
Button {
    Widget _super;
    alias _super this;

    void
    SDL_MOUSEBUTTONDOWN (SDL_MouseButtonEvent* evt) {
        if (!xywh.has (Xy (evt.x, evt.y))) return;
        writeln ("Button SDL_MOUSEBUTTONDOWN");

        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : this.PRESS (); page.redraw (&this._super); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    SDL_MOUSEBUTTONUP (SDL_MouseButtonEvent* evt) {
        if (!xywh.has (Xy (evt.x, evt.y))) return;

        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : this.RELEASE (); page.redraw (&this._super); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    PRESS () {
        with (o) {
            flags.pressed = true;
            hub.PRESSED ();
        }
    }

    void
    RELEASE () {
        with (o) {
            flags.pressed = false; 
            hub.RELEASED ();
        }
    }

    void
    draw (Style* style, Renderer* renderer) {
        with (o)
        with (style)
        with (xywh)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,style.get.fg,style.get.bg);

        with (o)
        with (style)
        with (xywh)
        if (text) {
            auto text_index = value;
            text_index = value;
            import std.utf;
            import std.range;
            import std.array;
            import std.conv;
            import std.uni;
            auto str = style.get.text;
            string txt;

            txt = str.byGrapheme
                .array
                .drop (text_index)
                .take (1)
                .byCodePoint
                .text;

            renderer.draw_text (get.font,x,y,w,h,style.get.fg,style.get.bg,txt);
        }
    }
}
