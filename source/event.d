module event;

struct
Event {
union {
    Type       type;
    Event_sdl  sdl;
    Event_draw draw;
    Event_open open;
    Event_quit quit;
    Event_play play;
}

    enum
    Type {
        _,
        SDL,
        OPEN,
        QUIT,
        DRAW,
        //CLICKED,
        PLAY,
    }
}
struct
Event_sdl {
    Event.Type type = Event.Type.SDL;

    import importc;
    SDL_Event sdl_event;
}
struct
Event_draw {
    Event.Type type = Event.Type.DRAW;
    import importc;
    Tvg_Canvas canvas;
}
struct
Event_open {
    Event.Type type = Event.Type.OPEN;
}
struct
Event_quit {
    Event.Type type = Event.Type.QUIT;
}
struct
Event_play {
    Event.Type type = Event.Type.PLAY;
    int id;
}
