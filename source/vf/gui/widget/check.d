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
    this (Hub* hub, Page page) {
        super (hub,page);
    }        

    override
    void
    on_sdl_mousebuttondown (SDL_MouseButtonEvent* evt) {
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
    on_sdl_mousebuttonup (SDL_MouseButtonEvent* evt) {
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
