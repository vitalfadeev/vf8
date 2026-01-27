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
        // video
        DRAW,
        //CLICKED,
        // audio
        PLAY,
        // ui
        SET_E_PROP,
        UPDATE,
        UPDATE_XY,
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
struct
Event_update {
    auto type     = Event.Type.UPDATE;
    auto strategy = Strategy._;

    enum
    Strategy {
        _,
        wh,
        hw,
    }
}
struct
Event_set_e_prop {
    auto type = Event.Type.SET_E_PROP;
}
struct
Event_update_xy {
    auto  type = Event.Type.UPDATE_XY;
    // left
    float line_height = 64.0;

    template
    tpl () {
        mixin Xywh!E_ui;
        mixin Layout!E_ui;        
    }
}
