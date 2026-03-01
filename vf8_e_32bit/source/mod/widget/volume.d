module mod.widget.volume;

version (SDL):
import app : Event,EType;
import mod.widget : Widget,Do_switch,Create;
import vf.sdl.importc_sdl;
import mod.widget.button;
import mod.volume;


struct
Volume {
    Button _super;
    alias _super this;
    mixin Do_switch;
    mixin Create;

    void
    SDL_MOUSEWHEEL (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.wheel)
        switch (direction) with (SDL_MouseWheelDirection) {
            case SDL_MOUSEWHEEL_NORMAL  : send (VOLUME_UP); break;
            case SDL_MOUSEWHEEL_FLIPPED : send (VOLUME_DN); break;
            default                     :
        }
    }

    void
    VOLUME_INFO (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.volume)
        switch (volume_type) with (Mod_volume.Volume_type) {
            case MUTE : value = 0; break;
            case LOW  : value = 1; break;
            case MID  : value = 2; break;
            case HIGH : value = 3; break;
            default   :
        }
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
