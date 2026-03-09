module mod.widget.check;

version (SDL):
import vf.sdl.importc_sdl;
import mod.widget.button   : Button;
import mod.widget          : Widget;
import vf.sdl.renderer_sdl : Renderer;
import vf.std.xywh         : Xy;
import std.stdio : writeln;
import app : o;


struct
Check {
    Button _super;
    alias _super this;

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
    press () {
        with (o) {
            if (flags.pressed)
                flags.pressed = false;
            else
                flags.pressed = true;
            on.pressed ();
            redraw ();
        }
    }

    void
    release () {
        with (o) {
            on.released ();
            redraw ();
        }
    }

    void
    style () {
        _super.style ();
    }

    void
    draw (Renderer* renderer) {
        if (style_dg !is null) style_dg ();
        _super.draw (renderer);
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

