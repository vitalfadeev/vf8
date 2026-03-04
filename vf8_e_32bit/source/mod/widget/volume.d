module mod.widget.volume;

version (SDL):
import app : Event;
import mod.widget : Widget,Create;
import vf.sdl.importc_sdl;
import mod.widget.button;
import mod.volume;
import std.stdio : writeln;
import vf.std.xywh : XYWH;


struct
Volume {
    Button _super;
    alias _super this;
    mixin Create;
    //mixin OpDispatch;

    void
    SDL_MOUSEWHEEL (SDL_MouseWheelEvent* evt) {
        with (o)
        with (evt)
        switch (direction) with (SDL_MouseWheelDirection) {
            case SDL_MOUSEWHEEL_NORMAL  : hub.VOLUME_UP (); writeln (1); break;
            case SDL_MOUSEWHEEL_FLIPPED : hub.VOLUME_DN (); break;
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
        with (o)
        //send (REDRAW, 1, null, XYWH());
        hub.REDRAW (cast (uint)1, XYWH());
        //(cast(Widget)this).REDRAW (1, null, XYWH());
        //(this.as!Widget).REDRAW (1, null, XYWH());
    }

    //void
    //DRAW (Event* evt) {
    //    _super.DRAW (evt);
    //}

    struct
    _Event {
        enum
        Type {
            PRESS,    // request
            PRESSED,
            PRESS_INFO,
            RELEASE,  // request
            RELEASED,
            RELEASE_INFO,
        }
    }    
}
