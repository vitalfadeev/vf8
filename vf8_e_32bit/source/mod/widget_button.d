module mod.widget_button;

import app : Event;
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
    }

    void
    _do_sdl_button_dn (Event* evt) {
        auto e = &evt.o.page.es[evt.i];

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
        auto e = &evt.o.page.es[evt.i];

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

    void
    _do_draw (Event* evt) {
        auto e = &evt.o.page.es[evt.i];
        auto style = evt.o.styles.get_e_style (*e);

        with (evt.o)
        with (evt.draw)
        with (evt.xywh)
        with (style)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,colors.s[fg],colors.s[bg]);

        with (evt.o)
        with (evt.draw)
        with (evt.xywh)
        with (style)
        if (text) {
            auto text_index = e.flags2;
            text_index = 0;
            import std.utf;
            import std.range;
            import std.array;
            import std.conv;
            import std.uni;
            auto str = strings.s[text];
            string txt;

            txt = str.byGrapheme
                .array
                .drop (text_index)
                .take (1)
                .byCodePoint
                .text;

            renderer.draw_text (font,x,y,w,h,colors.s[fg],colors.s[bg],txt);
        }
    }
}
