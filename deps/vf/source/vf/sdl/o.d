module vf.sdl.o;

import vf.sdl.input   : Input;
import vf.sdl.send    : Send;
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

    mixin Send!Event;
}

