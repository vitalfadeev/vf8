module mod.widget_button;

version (X)
struct
Widget_button {  // e.type = WIDGET_BUTTON
    void
    do_switch (Event* evt) {
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_MOUSEBUTTONDOWN : _do_sdl_button_dn  (evt); break;
            case SDL_MOUSEBUTTONUP   : _do_sdl_button_up  (evt); break;
            default                  :
        }
    }

    void
    _do_sdl_button_dn (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button)
        switch (button) {
            case SDL_BUTTON_LEFT   : e.pressed = true; break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    _do_sdl_button_up (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button)
        switch (button) {
            case SDL_BUTTON_LEFT   : e.pressed = false; break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }
}
