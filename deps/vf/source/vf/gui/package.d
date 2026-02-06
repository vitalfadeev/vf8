module vf.gui;

version (GUI):
import vf.gui.e : E;


struct
Gui (O,Event) {
    E* main_e;

    void
    go (void* o, Event* evt) {
        version (LAUOUT) 
        with (cast (O!Event*) o)
        with (Event.Type)
        switch (evt.type) {
            case ATTR    : _attr    (evt,main_e); break;
            case LAYOUT  : _layout  (evt,main_e); break;
            default      :
        }
        
        version (FIXED_LAUOUT) 
        with (cast (O*) o)
        with (Event.Type)
        switch (evt.type) {
            case DRAW    : _draw_e  (evt,main_e); break;
            default      :
        }
        // on
        version (ON) 
        _on (evt,main_e);
    }

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

    version (KLASSES)
    void
    _attr (Event* evt, E* e) {
        foreach (_e; e.childs_recursive)
            foreach (_k; _e.klasses)
                _e.set_attrs (_k);
    }

    void
    _layout (Event* evt, E* e) {
        //foreach (_e; e.childs_recursive ()) {
        //    if (_e.has_childs) 
        //        _e.go_layout (evt);
        //}
    }

    version (FIXED_LAUOUT)
    void
    _draw_e (Event* evt, E* e) {
        if (e !is null)
        foreach (_e; e.childs_recursive)
            with (_e) {
                version (THORVG) import vf.sdl.renderer_thorvg : draw_rect;
                version (THORVG) draw_rect (evt.draw.canvas, x,y, w,h, fg, bg);
            }
    }

    version (ON) 
    void
    _on (Event* evt, E* main_e) {
        import vf.sdl.importc;

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
                if (_select (e,x,y))
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
}
