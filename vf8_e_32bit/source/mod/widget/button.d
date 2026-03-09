module mod.widget.button;

version (SDL):
import mod.widget          : Widget;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.std.xywh         : Xywh;
import vf.std.xywh         : Xy;
import std.stdio : writeln;
import app : o;


struct
Button {
    Widget _super;
    alias _super this;

    void
    on_sdl_mousebuttondown (SDL_MouseButtonEvent* evt) {
        //if (!xywh.has (Xy (evt.x, evt.y))) return;

        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : this.press (); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    on_sdl_mousebuttonup (SDL_MouseButtonEvent* evt) {
        //if (!xywh.has (Xy (evt.x, evt.y))) return;

        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : this.release (); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    press () {
        with (o) {
            flags.pressed = true;
            on.pressed ();
            redraw ();
        }
    }

    void
    release () {
        with (o) {
            flags.pressed = false; 
            on.released ();
            redraw ();
        }
    }

    void
    style () {
        if (!text.length) text = [''];
        //xywh.w = 64;
        //xywh.h = 64;
        if (flags.pressed) {
            fg = 0xFFFFFFFF;  // 5
            bg = 0xFF888888;  // 2
        } else {
            fg = 0xFFCCCCCC; // 3
            bg = 0xFF444444; // 1
        }
    }

    void
    draw (Renderer* renderer) {
        writeln ("Button draw");
        if (style_dg !is null) style_dg ();

        with (xywh)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,fg,bg);

        with (xywh)
        if (text) {
            renderer.draw_text (page.fonts.s[1],x,y,w,h,fg,bg,text);
        }
    }
}
