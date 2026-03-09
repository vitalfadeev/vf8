module mod.widget.volume;

version (SDL):
import vf.sdl.importc_sdl;
import mod.widget.button   : Button;
import mod.widget          : Widget;
import vf.sdl.renderer_sdl : Renderer;
import vf.std.xywh         : Xy;
import std.stdio : writeln;
import app : o;


struct
Volume {
    Button _super;
    alias _super this;

    ubyte volume;

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
    up () {
        with (o)
        hub.VOLUME_UP ();
    }

    void
    dn () {
        with (o)
        hub.VOLUME_DN ();
    }

    void
    VOLUME_INFO (ubyte volume) {
        this.volume = volume;
        redraw ();
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

