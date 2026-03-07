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
    SDL_MOUSEBUTTONDOWN (SDL_MouseButtonEvent* evt) {
        if (!xywh.has (Xy (evt.x, evt.y))) return;

        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : this.PRESS (); break;
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
            case SDL_BUTTON_LEFT   : this.RELEASE (); break;
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
            hub.REDRAW (cast(Widget*)&this); 
        }
    }

    void
    RELEASE () {
        with (o) {
            flags.pressed = false; 
            hub.RELEASED ();
            hub.REDRAW (cast(Widget*)&this); 
        }
    }

    void
    style () {
        if (!text.length) text = [''];
        if (flags.pressed) {
            fg = 0xFFFFFFFF;  // 5
            bg = 0xFF888888;  // 2
        } else {
            fg = 0xFFCCCCCC; // 3
            bg = 0xFF444444; // 1
        }
    }

    void
    DRAW (Renderer* renderer) {
        if (style_dg !is null) style_dg ();

        with (o)
        with (xywh)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,fg,bg);

        with (o)
        with (xywh)
        if (text) {
            renderer.draw_text (page.fonts.s[1],x,y,w,h,fg,bg,text);
        }
    }
}
