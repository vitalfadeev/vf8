module mod.widget_volume;

import app : Event;
import vf.sdl.importc_sdl;
import mod.widget_button;
import mod.volume;


struct
Widget_volume {  // e.type = WIDGET_VOLUME
    Widget_button _super;

    void
    do_switch (Event* evt) {
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_MOUSEWHEEL      : _do_sdl_mousewheel (evt); break;
            default                  :
        }

        switch (evt.type) with (Event.Type) {
            case VOLUME_INFO         : _do_volume_info (evt); break;
            default                  :
        }

        _super.do_switch (evt);
    }

    void
    _do_sdl_button (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button)
        switch (button) {
            case SDL_BUTTON_LEFT   : break;
            case SDL_BUTTON_MIDDLE : send (VOLUME_MUTE); break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    _do_sdl_mousewheel (Event* evt) {
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
    _do_volume_info (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.volume)
        switch (volume_type) with (Mod_volume.Volume_type) {
            case MUTE : evt.e.value = 0; break;
            case LOW  : evt.e.value = 1; break;
            case MID  : evt.e.value = 2; break;
            case HIGH : evt.e.value = 3; break;
            default   :
        }
    }
}

//struct
//Styles_range {
//    Styles* styles;
//    ubyte   type;

//    void
//    icon (string icon_name) {
//        icon (icon_name.to_icon_id);
//    }

//    void
//    icon (ubyte icon_id) {
//        foreach (ref s; styles.styles[type])
//            s.icon = icon_id;
//    }
//}
