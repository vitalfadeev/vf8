module vf.sdl.o;

import vf.sdl.input   : Input;
import vf.sdl.importc : SDL_Init,SDL_INIT_EVENTS,SDL_INIT_EVERYTHING;
version (WINDOW) import vf.sdl.window;
version (AUDIO)  import vf.sdl.audio;
version (THORVG) import vf.sdl.renderer_thorvg;

struct
O (Event) {
    Input!Event _input;
    auto         input () { return _input.range; };
    GO           go;
    version (WINDOW) Window   window;
    version (AUDIO)  Audio    audio;
    version (THORVG) Renderer renderer;

    alias GO = void function (void* o, Event* evt);

    this (GO go) {
        this.go = go;
        init_engine ();
    }

    void
    init_engine () {
        //SDL_Init (SDL_INIT_EVENTS);
        SDL_Init (SDL_INIT_EVERYTHING);
    }

    //
    void
    send_now (Event* evt) {
        assert (go !is null);
        if (go !is null) 
            go (&this,evt);
    }

    void
    send_now (Event evt) {
        assert (go !is null);
        if (go !is null) 
            go (&this,&evt);
    }

    void
    send_now (Event.Type type) {
        assert (go !is null);
        Event event;
        event.type = type;
        if (go !is null) 
            go (&this,&event);
    }

    void
    send (Event* event) {
        _input ~= event;
    }

    void
    send (Event event) {
        _input ~= &event;
    }

    void
    send (Event.Type type) {
        Event event;
        event.type = type;
        _input ~= &event;
    }
}

