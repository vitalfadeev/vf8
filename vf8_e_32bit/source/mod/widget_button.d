module mod.widget_button;

import app : Event,EType;
import vf.sdl.importc_sdl;

struct
Widget_button {  // e.type = WIDGET_BUTTON
    void
    do_switch (Event* evt) {
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_MOUSEBUTTONDOWN : _do_sdl_button_dn  (evt); break;
            case SDL_MOUSEBUTTONUP   : _do_sdl_button_up  (evt); break;
            default                  :
        }

        switch (evt.type) with (Event.Type) {
            case DRAW : _do_draw (evt); break;
            default   :
        }

        switch (evt.type) with (Event.Type) {
            case PRESS   : _do_press   (evt); break;
            case RELEASE : _do_release (evt); break;
            default      :
        }
    }

    void
    _do_sdl_button_dn (Event* evt) {
        auto e = &evt.o.page.es[evt.i];

        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button)
        switch (button) {
            case SDL_BUTTON_LEFT   : e.pressed = true; send (PRESSED); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    _do_sdl_button_up (Event* evt) {
        auto e = &evt.o.page.es[evt.i];

        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button)
        switch (button) {
            case SDL_BUTTON_LEFT   : e.pressed = false; send (RELEASED); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    _do_press (Event* evt) {
        auto e = &evt.o.page.es[evt.i];

        with (evt.o)
        with (Event.Type){
            e.pressed = true; 
            send (PRESSED);
        }
    }

    void
    _do_release (Event* evt) {
        auto e = &evt.o.page.es[evt.i];

        with (evt.o)
        with (Event.Type){
            e.pressed = false; 
            send (RELEASED);
        }
    }

    void
    _do_draw (Event* evt) {
        auto e = &evt.o.page.es[evt.i];
        auto style = evt.o.page.styles.get_e_style (*e);

        with (evt.o)
        with (evt.draw)
        with (evt.xywh)
        with (style)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,page.colors.s[fg],page.colors.s[bg]);

        with (evt.o)
        with (evt.draw)
        with (evt.xywh)
        with (style)
        if (text) {
            auto text_index = e.value;
            text_index = 0;
            import std.utf;
            import std.range;
            import std.array;
            import std.conv;
            import std.uni;
            auto str = page.strings.s[text];
            string txt;

            txt = str.byGrapheme
                .array
                .drop (text_index)
                .take (1)
                .byCodePoint
                .text;

            renderer.draw_text (font,x,y,w,h,page.colors.s[fg],page.colors.s[bg],txt);
        }
    }

    struct
    _Event {
        EType type;

        // send (WIDGET, BUTTON, PRESSED)
        // send (WIDGET_BUTTON_PRESSED)
        // send (WIDGET_BUTTON, PRESSED)
        // send (WIDGET + type, PRESSED)
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
