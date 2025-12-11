module vf.input;

import importc;


struct
Input {
    void
    open () {
        //SDL_Init (SDL_INIT_EVENTS);
    }

    bool 
    read (Event* event) {
        return (SDL_WaitEvent (event) == 1);
    }

    //void
    //register_custom_event () {
    //    Uint32 custom_event_type = SDL_RegisterEvents (1);
    //    if (custom_event_type == cast(Uint32)-1) {
    //        // Handle error
    //    }
    //}
}

alias Event = SDL_Event;
