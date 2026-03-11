module vf.gui.widget.check;

version (SDL):
import vf.sdl.importc_sdl;
import vf.gui.widget.button : Button;
import vf.gui.widget        : Widget;
import vf.gui.page          : Page;
import vf.sdl.renderer_sdl  : Renderer;
import vf.std.xywh          : Xy;
import std.stdio : writeln;
import app : o;
import hub : Hub;


class
Check : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        

    override
    void
    sdl_event_mouse_button_down (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : this.press (); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    override
    void
    sdl_event_mouse_button_up (SDL_MouseButtonEvent* evt) {
        with (o)
        with (evt)
        switch (button) {
            case SDL_BUTTON_LEFT   : this.release (); break;
            case SDL_BUTTON_MIDDLE : break;
            case SDL_BUTTON_RIGHT  : break;
            case SDL_BUTTON_X1     : break;
            case SDL_BUTTON_X2     : break;
            default                :
        }
    }

    override
    void
    press () {
        with (o) {
            if (flags.pressed)
                flags.pressed = false;
            else
                flags.pressed = true;
            //on.pressed ();
            redraw ();
        }
    }

    override
    void
    release () {
        with (o) {
            //on.released ();
            redraw ();
        }
    }

    override
    void
    style () {
        super.style ();
    }

    override
    void
    draw (Renderer* renderer) {
        style ();
        super.draw (renderer);
    }
}
