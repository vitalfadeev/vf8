module mod.quick_settings;

import vf.gui.page                      : Page;
import app : o;


struct
Quick_settings {
    void
    QUICK_SETTINGS () {
        // Page_qs
        // window
        with (o) {
            auto page = new Page_qs ();
            pages ~= cast (Page*) page;

            page._init ();
        }
    }
}

struct
Page_qs {
    Page _super;
    alias _super this;

    void
    _init () {
        _init_colors  ();
        _init_fonts   ();
        _init_images  ();
        _init_widgets ();
        _init_window  ();
    }

    void
    _init_window () {
        import mod.sdl_wm;
        with (o)
        Sdl_wm ().new_window (wh.w, wh.h, &window);
    }

    void
    style () {
        wh.w = 320;
        wh.h = 600;
    }
}

