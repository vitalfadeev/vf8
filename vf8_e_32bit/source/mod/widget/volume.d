module mod.widget.volume;

version (SDL):
import app : Event;
import mod.widget : Widget;
import vf.sdl.importc_sdl;
import mod.widget.button;
import std.stdio : writeln;
import vf.sdl.renderer_sdl : Renderer;


struct
Volume {
    Button _super;
    alias _super this;

    void
    SDL_MOUSEBUTTONDOWN (SDL_MouseButtonEvent* evt) {
        _super.SDL_MOUSEBUTTONDOWN (evt);
    }

    void
    SDL_MOUSEBUTTONUP (SDL_MouseButtonEvent* evt) {
        _super.SDL_MOUSEBUTTONUP (evt);
    }

    void
    SDL_MOUSEWHEEL (SDL_MouseWheelEvent* evt) {
        with (o)
        with (evt)
        switch (direction) with (SDL_MouseWheelDirection) {
            case SDL_MOUSEWHEEL_NORMAL  : (y > 0)? hub.VOLUME_UP (): hub.VOLUME_DN (); hub.REDRAW (windowID); break;
            case SDL_MOUSEWHEEL_FLIPPED : (y < 0)? hub.VOLUME_DN (): hub.VOLUME_DN (); hub.REDRAW (windowID); break;
            default                     :
        }
    }

    void
    VOLUME_INFO (ubyte volume) {
        with (o)
        switch (volume_type (volume)) with (Volume_type) {
            case MUTE : value = 0; break;
            case LOW  : value = 1; break;
            case MID  : value = 2; break;
            case HIGH : value = 3; break;
            default   :
        }

        with (o)
        hub.REDRAW (/*windowID*/cast (uint) 1);
    }

    void
    DRAW (Renderer* renderer) {
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

