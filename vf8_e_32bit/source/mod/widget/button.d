module mod.widget.button;

version (SDL):
import app : Event;
import mod.widget : Widget,Create;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import vf.std.xywh : XYWH;


struct
Button {
    Widget _super;
    alias _super this;
    mixin Create;

    void
    SDL_MOUSEBUTTONDOWN (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : flags.pressed = true; hub.PRESSED (); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    SDL_MOUSEBUTTONUP (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : flags.pressed = false; hub.RELEASED (); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    void
    PRESS () {
        with (o) {
            flags.pressed = true; 
            hub.PRESSED ();
        }
    }

    void
    RELEASE () {
        with (o) {
            flags.pressed = false; 
            hub.RELEASED ();
        }
    }

    void
    DRAW (Renderer* renderer, XYWH xywh) {
        auto style = o.page.styles.get_style (cast (Widget*) &this);
        //auto style = evt.o.page.styles.get (name,flags);

        with (o)
        with (style)
        with (xywh)
        if (w > 0 && h > 0)
            renderer.draw_rect (x,y,w,h,page.colors.s[fg],page.colors.s[bg]);

        with (o)
        with (style)
        with (xywh)
        if (text) {
            auto text_index = value;
            text_index = value;
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
