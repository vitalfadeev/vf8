module vf.gui.widget.button;

version (SDL):
import vf.gui.widget       : Widget,On;
import vf.gui.page         : Page;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.std.xywh         : Xywh;
import vf.std.xywh         : Xy;
import std.stdio : writeln;
import app : o;
import hub : Hub;


class
Button : Widget {
    this (Hub* hub, Page page) {
        super (hub,page);
        hub.register (this);
    }        

    override
    void
    sdl_mousebuttondown (SDL_MouseButtonEvent* evt) {
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

    override
    void
    sdl_mousebuttonup (SDL_MouseButtonEvent* evt) {
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
            pressed ();
            redraw ();
        }
    }

    void
    release () {
        with (o) {
            flags.pressed = false; 
            released ();
            redraw ();
        }
    }

    void
    pressed () {
        //
    }

    void
    released () {
        //
    }

    override
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

    override
    void
    draw (Renderer* renderer) {
        style ();

        with (xywh)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,fg,bg);

        with (xywh)
        if (text) {
            renderer.draw_text (page.fonts.s[1],x,y,w,h,fg,bg,text);
        }
    }
}
