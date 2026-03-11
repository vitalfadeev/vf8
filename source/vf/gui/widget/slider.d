module vf.gui.widget.slider;

version (SDL):
import vf.sdl.importc_sdl;
import vf.gui.widget.button : Button;
import vf.gui.widget        : Widget;
import vf.gui.page          : Page;
import vf.sdl.renderer_sdl  : Renderer;
import vf.std.xywh          : Xy;
import std.stdio : writeln;
import app : o;
import hub : Hub;


class
Slider : Button {
    ubyte value;

    this (Page page) {
        super (page);
        o.hub.register (this);
    }        

    override
    void
    sdl_event_mouse_button_down (SDL_MouseButtonEvent* evt) {
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
    sdl_event_mouse_button_up (SDL_MouseButtonEvent* evt) {
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

    override
    void
    sdl_event_mouse_wheel (SDL_MouseWheelEvent* evt) {
        with (o)
        with (evt)
        switch (direction) with (SDL_MouseWheelDirection) {
            case SDL_MOUSEWHEEL_NORMAL  : (y > 0)? up (): dn (); redraw (); break;
            case SDL_MOUSEWHEEL_FLIPPED : (y < 0)? dn (): up (); redraw (); break;
            default                     :
        }
    }

    override
    void
    press () {
        with (o) {
            flags.pressed = true;
            //on.pressed ();
            redraw ();
        }
    }

    override
    void
    release () {
        with (o) {
            flags.pressed = false;
            //on.released ();
            redraw ();
        }
    }

    void
    up () {
        value += value.max/100*5;
    }

    void
    dn () {
        value -= value.max/100*5;
    }

    override
    void
    style () {
        super.style ();
    }

    override
    void
    draw (Renderer* renderer) {
        style ();

        // bg,border
        with (xywh)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,fg,bg);

        // cusor
        with (xywh)
        if (w > 0 && h > 0) {
            bg = 0xFF888888;  // 2
            auto cur_w = w * value/value.max;
            renderer.draw_rect (x,y,cur_w,h,fg,bg);
        }
    }
}
