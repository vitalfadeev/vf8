module mod.widget.slider;

version (SDL):
import vf.sdl.importc_sdl;
import mod.widget.button   : Button;
import mod.widget          : Widget;
import vf.sdl.renderer_sdl : Renderer;
import vf.std.xywh         : Xy;
import std.stdio : writeln;
import app : o;


struct
Slider {
    Button _super;
    alias _super this;

    ubyte value;

    void
    on_sdl_mousebuttondown (SDL_MouseButtonEvent* evt) {
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
    on_sdl_mousewheel (SDL_MouseWheelEvent* evt) {
        with (o)
        with (evt)
        switch (direction) with (SDL_MouseWheelDirection) {
            case SDL_MOUSEWHEEL_NORMAL  : (y > 0)? up (): dn (); redraw (); break;
            case SDL_MOUSEWHEEL_FLIPPED : (y < 0)? dn (): up (); redraw (); break;
            default                     :
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
    up () {
        value += value.max/100*5;
    }

    void
    dn () {
        value -= value.max/100*5;
    }

    void
    style () {
        _super.style ();
    }

    void
    draw (Renderer* renderer) {
        if (style_dg !is null) style_dg ();

        // bg,border
        with (xywh)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,fg,bg);

        // cusor
        with (xywh)
        if (w > 0 && h > 0) {
            auto cur_w = w * value/value.max;
            renderer.draw_rect (x,y,cur_w,h,fg,bg);
        }
    }
}

Volume_type
volume_type (ubyte volume) {
    with (Volume_type) {
        if (volume == 0)               return MUTE;
        if (volume < volume.max/3)     return LOW;
        if (volume < (volume.max/3)*2) return MID;
        return HIGH;
    }
}

enum
Volume_type {
    MUTE,
    LOW,
    MID,
    HIGH,
}
