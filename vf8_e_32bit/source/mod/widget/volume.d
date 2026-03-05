module mod.widget.volume;

version (SDL):
import app : Event;
import mod.widget : Widget;
import vf.sdl.importc_sdl;
import mod.widget.button;
import mod.volume;
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
            case SDL_MOUSEWHEEL_NORMAL  : hub.VOLUME_UP (); hub.REDRAW (windowID); break;
            case SDL_MOUSEWHEEL_FLIPPED : hub.VOLUME_DN (); hub.REDRAW (windowID); break;
            default                     :
        }
    }

    void
    VOLUME_INFO () {
        //with (evt.o)
        //with (Event.Type)
        //with (evt.volume)
        //switch (volume_type) with (Mod_volume.Volume_type) {
        //    case MUTE : value = 0; break;
        //    case LOW  : value = 1; break;
        //    case MID  : value = 2; break;
        //    case HIGH : value = 3; break;
        //    default   :
        //}

        //with (o)
        //hub.REDRAW (windowID);
    }

    void
    DRAW (Renderer* renderer) {
        writeln ("DRAW on Volume");
        _super.DRAW (renderer);
    }
}
