module event;

struct
Event {
union {
    Type             type;
    Event_sdl        sdl;
    Event_draw       draw;
    Event_draw       click;
    Event_open       open;
    Event_quit       quit;
    Event_play       play;
    Event_update     update;
    Event_set_e_prop set_e_prop;
    Event_update_xy  update_xy;
}

    string
    toString () {
        import std.format;
        return format!"%s (%s)" (typeof(this).stringof, type);
    }

    enum
    Type {
        _,
        SDL,
        OPEN,
        QUIT,
        // video
        DRAW,
        CLICK,
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

    template
    tpl () {
        Color  bg;
        Color  fg;
        string text;
        alias Color = uint;
    }

    import importc;
    import layout;
    void
    draw_rect (Tvg_Canvas canvas, XY xy, XY wh) {
        ubyte bg_r, bg_g, bg_b, bg_a;
        bg_r = bg_g = bg_b = bg_a = 255;
        Tvg_Paint shape = tvg_shape_new ();
        //tvg_shape_append_rect (shape, x, y, w, h, 0.0f, 0.0f, true);
        tvg_shape_append_rect (shape, xy.x, xy.y, wh.w, wh.h, 0.0f, 0.0f, true);
        tvg_shape_set_fill_color (shape, bg_r, bg_g, bg_b, bg_a);

        //Push the shape into the canvas
        tvg_canvas_push (canvas, shape);
    }

    void
    draw_text (Tvg_Canvas canvas, XY xy, XY wh, string text) {
        {
            //import importc;

            //auto canvas = cast (Tvg_Canvas) d;

            ////
            //if (tvg_font_load (font_file.ptr) != TVG_RESULT_SUCCESS) {
            //    printf ("Problem with loading the font from the file. Did you enable TTF Loader?\n");
            //}

            //Tvg_Paint _text = tvg_text_new ();
            //tvg_text_set_font   (_text, font_name.ptr);
            //tvg_text_set_size   (_text, font_size);
            //tvg_text_set_color  (_text, font_color_r, font_color_g, font_color_b);
            //tvg_text_set_text   (_text, text.ptr);
            //tvg_paint_translate (_text, x, y);
            //tvg_canvas_push (canvas, _text);
        }
    }
}
struct
Event_click {
    auto type = Event.Type.CLICK;

    template
    tpl () {
        Event.Type on_click_send_evt_code;  // PLLAY_1
    }
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
