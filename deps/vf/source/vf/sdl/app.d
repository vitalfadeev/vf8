module vf.sdl.app;

import vf.sdl.o     : O;
import vf.sdl.event : Event;
version (GUI) import vf.gui.e : E;

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
        case OPEN: 
            version (WINDOW) window.open ();
            break;
        default:
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
            version (THORVG) renderer.init_engine ();
            break;
        case SDL_WINDOWEVENT:
            with (evt.sdl.window)
            switch (event) {
                case SDL_WINDOWEVENT_EXPOSED: 
                    version (THORVG) renderer.draw_start (o,evt);
                    version (THORVG) send_now (Event(Event.Draw(DRAW,renderer.canvas)));
                    version (THORVG) renderer.draw_end   (o,evt);
                    break;
                case SDL_WINDOWEVENT_CLOSE: 
                    send (QUIT);
                    break;
                default:
            }
            break;
        case DRAW:
            version (THORVG) import vf.sdl.renderer_thorvg : draw_rect;
            version (THORVG) draw_rect (evt.draw.canvas, 1,1, 100,100, 0xFF222222, 0xFFCCCCCC);
            break;
        default:
    }

    // GUI
    version (GUI) static E* main_e;

    version (GUI) 
    with (cast (O!Event*) o)
    with (Event.Type)
    switch (evt.type) {
        case LOAD_UI : version (GUI) _load_ui (evt,&main_e); break;
        //case ATTR    : version (GUI) _attr    (evt,main_e); break;
        case LAYOUT  : version (GUI) _layout  (evt,main_e); break;
        case DRAW    : version (GUI) _dtaw_e  (evt,main_e); break;
        default      :
    }

    // on
    version (GUI) 
    _on (evt,main_e);
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

version (KLASSES)
void
_attr (Event* evt, E* e) {
    foreach (_e; e.childs_recursive)
        foreach (_k; _e.klasses)
            _e.set_attrs (_k);
}

version (GUI) 
void
_layout (Event* evt, E* e) {
    //foreach (_e; e.childs_recursive ()) {
    //    if (_e.has_childs) 
    //        _e.go_layout (evt);
    //}
}

version (GUI) 
version (THORVG)
version (FIXED_LAUOUT)
void
_dtaw_e (Event* evt, E* e) {
    if (e !is null)
    foreach (_e; e.childs_recursive)
        with (_e) {
            import vf.sdl.renderer_thorvg : draw_rect;
            draw_rect (evt.draw.canvas, x,y, w,h, fg, bg);
        }
}

version (WINDOW)
version (GUI) 
void
_on (Event* evt, E* main_e) {
    import vf.sdl.importc;

    auto gui = GUI (main_e);

    // key,mmouse: code,modifiers,x,y;
    bool redraw = false;
    uint code;
    uint modifiers;
    uint x,y;
    switch (evt.type) with (Event.Type) {
        case SDL_MOUSEBUTTONDOWN : code = evt.sdl.button.button; modifiers = SDL_GetModState (); x = evt.sdl.button.x; y = evt.sdl.button.y; break;
        case SDL_MOUSEBUTTONUP   : code = evt.sdl.button.button; modifiers = SDL_GetModState (); x = evt.sdl.button.x; y = evt.sdl.button.y; break;
        case SDL_KEYDOWN         : code = evt.sdl.key.keysym.scancode; modifiers = evt.sdl.key.keysym.mod; break;
        case SDL_KEYUP           : code = evt.sdl.key.keysym.scancode; modifiers = evt.sdl.key.keysym.mod; break;
        default:
    }
    modifiers &= (KMOD_CTRL | KMOD_SHIFT | KMOD_ALT | KMOD_GUI);

    // each e on
    foreach (e; main_e.childs_recursive) {
        // check mouse widget by xy
        with (evt.type)
        if (evt.type == SDL_MOUSEBUTTONDOWN || evt.type == SDL_MOUSEBUTTONUP) {
            if (gui._select (e,x,y))
                {} // allow
            else
                continue;
        }

        // on
        auto rec = e._on.select (evt.type,code,modifiers);
        if (rec !is null) {
            // call dg
            if (rec.dg !is null) {
                rec.dg ();
                redraw = true;
            }

            //// send event
            //if (rec.new_event.type) {
            //    send (rec.new_event);
            //    redraw = true;
            //}
            //// add klass
            //if (rec.klass.length)
            //if (rec.klass[0] != '-') {
            //    auto kls = select_klass (rec.klass);
            //    if (kls !is null) {
            //        e.add_klass (kls);
            //        redraw = true;
            //    }
            //}
            //// rem klass
            //if (rec.klass.length)
            //if (rec.klass[0] == '-') {
            //    auto kls = select_klass (rec.klass[1..$]);
            //    if (kls !is null) {
            //        e.rem_klass (kls);
            //        redraw = true;
            //    }
            //}
        }

        //with (Event.Type)
        //if (redraw) {
        //    send (ATTR);
        //    send (LAYOUT);
        //    send (REDRAW); // xy,wh
        //}
    }    
}

version (GUI) 
struct
GUI {
    E* main_e;

    E*
    select (E* e, int x, int y) {
        if (e !is null)
        if (_select (e,x,y)) {
            // childs
            foreach (c; e.childs) {
                if (_select (c,x,y)) {
                    auto cc = select (c,x,y);
                    if (cc !is null) return cc;
                    else return c;
                }
            }
        }

        return e;
    }

    bool
    _select (E* e, int x, int y) {
        auto _x = e.x;
        auto _y = e.y;
        if (_x <= x && _y < y) {
            auto _w = e.w;
            auto _h = e.h;
            if (x < (_x + _w) && y < (_y + _h)) {
                return true;
            }
        }

        return false;
    }
}
