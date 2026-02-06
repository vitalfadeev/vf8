module vf.sdl.app;

import vf.sdl.o               : O;
import vf.sdl.event           : Event;
version (GUI) import vf.gui.e : E;
version (GUI) import vf.gui   : Gui;

void
App () {
    auto o = O!Event (&go);
    with (o)
    with (Event.Type) {
        send (OPEN);
        version (GUI) send (LOAD_UI);

        bool send_first = true;
        bool send_force = true;

        foreach (Event* evt; input) {
            // OPEN
            // LOAD_UI
            // ...
            // QUIT
            if (send_first) { send_first = false; send (DO_1); }
            if (send_force) { send_force = false; send_now (DO_FORCED); }

            go (&o,evt);

            if (evt.type == SDL_QUIT) break;
            if (evt.type == QUIT) break;
        }
    }
}

void
go (void* o, Event* evt) {
    import std.stdio : writefln;
    with (Event.Type)
    if (evt.type == SDL_WINDOWEVENT)
        writefln ("go: %s 0x%04X", evt.type, evt.sdl.window.event);
    else
    if (evt.type == SDL_KEYDOWN)
        writefln ("go: %s %s", evt.type, evt.sdl.key.keysym.scancode);
    else
    if (evt.type == SDL_KEYUP)
        writefln ("go: %s %s", evt.type, evt.sdl.key.keysym.scancode);
    else
        writefln ("go: %s", evt.type);

    // WINDOW
    version (WINDOW)
    with (cast (O!Event*) o)
    with (Event.Type)
    switch (evt.type) {
        case OPEN : window.open (); break;
        default   :
    }

    // THORVG
    version (THORVG) 
    version (WINDOW)
    import importc : SDL_WINDOWEVENT_EXPOSED,SDL_WINDOWEVENT_CLOSE;
    version (THORVG) 
    version (WINDOW)
    with (cast (O!Event*) o)
    with (Event.Type)
    switch (evt.type) {
        case OPEN:
            renderer.init_engine ();
            break;
        case SDL_WINDOWEVENT:
            with (evt.sdl.window)
            switch (event) {
                case SDL_WINDOWEVENT_EXPOSED: 
                    renderer.draw_start (o,evt);
                    send_now (Event(Event.Draw(DRAW,renderer.canvas)));
                    renderer.draw_end   (o,evt);
                    break;
                case SDL_WINDOWEVENT_CLOSE: 
                    send (QUIT);
                    break;
                default:
            }
            break;
        case DRAW: 
            _draw (evt); 
            break;
        default:
    }

    // GUI
    version (GUI) static Gui!(O!Event,Event) gui;

    version (GUI)
    version (FIXED_LAUOUT) 
    with (cast (O!Event*) o)
    with (Event.Type)
    switch (evt.type) {
        case LOAD_UI : _load_ui (evt,&gui.main_e); break;
        default      :
    }

    gui.go (o,evt);
}

version (WINDOW) 
void
_draw (Event* evt) {
    version (THORVG) import vf.sdl.renderer_thorvg : draw_rect;
    version (THORVG) draw_rect (evt.draw.canvas, 1,1, 100,100, 0xFFCCCCCC, 0xFF888888);
}

version (GUI)
version (FIXED_LAUOUT)
void
_load_ui (Event* evt, E** e) {
    import vf.sdl.importc;

    auto e1 = new E ();
      auto e2 = new E ();
      auto e3 = new E ();
      auto e4 = new E ();
      e1.add_child (e2);
      e1.add_child (e3);
      e1.add_child (e4);

      e1.x  = 100;
      e1.y  = 100;
      e1.w  = 100;
      e1.h  = 100;
      e1.fg = 0xFFCCCCCC;
      e1.bg = 0xFF222222;
      with (Event.Type)
      e1.on (SDL_MOUSEBUTTONDOWN, SDL_BUTTON_LEFT, 0, () {
          import std.stdio : writefln;
          writefln ("_______CLICK_______");
      });

      e2.x  = 200;
      e2.y  = 200;
      e2.w  = 100;
      e2.h  = 100;
      e2.fg = 0xFFCCCCCC;
      e2.bg = 0xFF222222;

      e3.x  = 300;
      e3.y  = 300;
      e3.w  = 100;
      e3.h  = 100;
      e3.fg = 0xFFCCCCCC;
      e3.bg = 0xFF222222;

      e4.x  = 400;
      e4.y  = 400;
      e4.w  = 100;
      e4.h  = 100;
      e4.fg = 0xFFCCCCCC;
      e4.bg = 0xFF222222;

    *e = e1;
}

