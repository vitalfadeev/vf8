module event;

struct
Event {
union {
    Type             type;
    Event_base       base;
    Event_sdl        sdl;
    Event_open       open;
    Event_quit       quit;
    Event_draw       draw;
    Event_play       play;
    Event_update     update;
    Event_set_e_prop set_e_prop;
    Event_layout     layout;
    Event_click      click;
}
    this (Event_play  evt) { play  = evt; }
    this (Event_click evt) { click = evt; }

    string
    toString () {
        import std.format;
        return format!"%s (%s)" (typeof(this).stringof, type);
    }

    enum
    Type {
        _,
        OPEN,
        QUIT,
        // SDL
        SDL,
        // video
        DRAW,
        REDRAW,
        // audio
        PLAY,
        // ui
        UPDATE,
        SET_E_PROP,
        LAYOUT,
        CLICK,
    }
}
struct
Event_base {
    Event.Type type;
    void* o;
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
        Color  _bg;
        Color  _fg;
        string text;
        alias Color = uint;
    }
    alias Color = uint;  // aabbggrr

    import importc;
    import layout;
    void
    draw_rect (Tvg_Canvas canvas, XY xy, XY wh, Color bg, Color fg) {
        ubyte fg_r = (fg >>  0) & 0xFF;
        ubyte fg_g = (fg >>  8) & 0xFF;
        ubyte fg_b = (fg >> 16) & 0xFF;
        ubyte fg_a = (fg >> 24) & 0xFF;

        ubyte bg_r = (bg >>  0) & 0xFF;
        ubyte bg_g = (bg >>  8) & 0xFF;
        ubyte bg_b = (bg >> 16) & 0xFF;
        ubyte bg_a = (bg >> 24) & 0xFF;

        Tvg_Paint shape = tvg_shape_new ();
        tvg_shape_append_rect (shape, xy.x, xy.y, wh.w, wh.h, 0.0f, 0.0f, true);
        tvg_shape_set_fill_color (shape, bg_r, bg_g, bg_b, bg_a);
        tvg_shape_set_stroke_width (shape, 1);
        tvg_shape_set_stroke_color (shape, fg_r, fg_g, fg_b, fg_a);

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
    int  x;
    int  y;

    template
    tpl () {
        Event.Type on_click_send_evt_type;  // PLLAY
        int        on_click_send_evt_arg;   // 1
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
Event_layout {
    auto  type = Event.Type.LAYOUT;
    // left
    float line_height = 64.0;

    template
    tpl () {
        mixin Xywh!E;
        mixin Layout!E;
    }
}
