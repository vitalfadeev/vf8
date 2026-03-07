module mod.widget.volume;

version (SDL):
import mod.widget          : Widget;
import vf.sdl.importc_sdl;
import mod.widget.button;
import vf.sdl.renderer_sdl : Renderer;
import app : o;
import std.stdio : writeln;
import vf.std.xywh         : Xy;


struct
Volume {
    Button _super;
    alias _super this;

    ubyte volume;

    void
    SDL_MOUSEBUTTONDOWN (SDL_MouseButtonEvent* evt) {
        if (!xywh.has (Xy (evt.x, evt.y))) return;
        _super.SDL_MOUSEBUTTONDOWN (evt);
    }

    void
    SDL_MOUSEBUTTONUP (SDL_MouseButtonEvent* evt) {
        if (!xywh.has (Xy (evt.x, evt.y))) return;
        _super.SDL_MOUSEBUTTONUP (evt);
    }

    void
    SDL_MOUSEWHEEL (SDL_MouseWheelEvent* evt) {
        with (o)
        with (evt)
        switch (direction) with (SDL_MouseWheelDirection) {
            case SDL_MOUSEWHEEL_NORMAL  : (y > 0)? hub.VOLUME_UP (): hub.VOLUME_DN (); hub.REDRAW (cast (Widget*) &this); break;
            case SDL_MOUSEWHEEL_FLIPPED : (y < 0)? hub.VOLUME_DN (): hub.VOLUME_DN (); hub.REDRAW (cast (Widget*) &this); break;
            default                     :
        }
    }

    void
    VOLUME_INFO (ubyte volume) {
        this.volume = volume;

        with (o)
        hub.REDRAW (cast (Widget*) &this);
    }

    void
    style () {
        _super.style ();

        text_set = ['', '', '', ''];
        switch (volume_type (volume)) with (Volume_type) {
            case MUTE : text = text_set[0..1]; break;
            case LOW  : text = text_set[1..2]; break;
            case MID  : text = text_set[2..3]; break;
            case HIGH : text = text_set[3..4]; break;
            default   :
        }
    }

    void
    DRAW (Renderer* renderer) {
        if (style_dg !is null) style_dg ();
        _super.DRAW (renderer);
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

