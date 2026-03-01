module mod.widget.button;

version (SDL):
import app : Event,EType;
import mod.widget : Widget,_Widget,Do_switch;
import vf.sdl.importc_sdl;


struct
Button {
    mixin _Widget!(Widget.Type.BUTTON);

    void
    SDL_MOUSEBUTTONDOWN (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button)
        switch (button) {
            case SDL_BUTTON_LEFT   : flags.pressed = true; send_now (PRESSED); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    SDL_MOUSEBUTTONUP (Event* evt) {
        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button)
        switch (button) {
            case SDL_BUTTON_LEFT   : flags.pressed = false; send_now (RELEASED); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    PRESS (Event* evt) {
        with (evt.o)
        with (Event.Type){
            flags.pressed = true; 
            send (PRESSED);
        }
    }

    void
    RELEASE (Event* evt) {
        with (evt.o)
        with (Event.Type){
            flags.pressed = false; 
            send (RELEASED);
        }
    }

    void
    DRAW (Event* evt) {
        auto style = evt.o.page.styles.get_style (cast (Widget*) &this);
        //auto style = evt.o.page.styles.get (type,flags);

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
            auto text_index = value;
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
