module vf.gui.widget.volume;

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
Volume : Button {
    ubyte volume;

    this (Hub* hub, Page page) {
        super (hub,page);
    }        

    override
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

    override
    void
    style () {
        super.style ();

        text_set = ['', '', '', ''];
        switch (volume_type (volume)) with (Volume_type) {
            case MUTE : text = text_set[0..1]; break;
            case LOW  : text = text_set[1..2]; break;
            case MID  : text = text_set[2..3]; break;
            case HIGH : text = text_set[3..4]; break;
            default   :
        }
    }

    override
    void
    draw (Renderer* renderer) {
        style ();
        super.draw (renderer);
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

