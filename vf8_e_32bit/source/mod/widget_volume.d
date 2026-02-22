module mod.widget_volume;


version (X)
struct
Widget_volume {  // e.type = WIDGET_VOLUME
    void
    do_switch (Event* evt) {
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_MOUSEBUTTONDOWN : _do_sdl_button (evt); break;
            case SDL_MOUSEWHEEL      : _do_sdl_mousewheel (evt); break;
            default                  :
        }

        switch (evt.type) with (Event.Type) {
            case VOLUME_INFO         : _do_volume_info (evt); break;
            default                  :
        }
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
        switch (volume_type) with (Volume.Type) {
            case MUTE : e.reserved1 = 0; break;
            case LOW  : e.reserved1 = 1; break;
            case MID  : e.reserved1 = 2; break;
            case HIGH : e.reserved1 = 3; break;
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
