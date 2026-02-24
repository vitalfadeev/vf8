module page2;

import vf.gui.page : Page;


struct
Page2 {
    Page _super;

    void
    _init () {
        //_init_colors  ();
        //_init_fonts   ();
        //_init_icons   ();
        //_init_strings ();
        //_init_widgets ();
        //version (ACTIONS) _init_actions ();
        //_init_styles  ();
        //_init_es      ();
        _init_layout  ();
    }

    void
    _init_layout () {
        with (_super)
        with (layout.quick_settings) {
            import vf.sdl.window : WINDOW_DEFAULT_W, WINDOW_DEFAULT_H;
            total_wh.w     = WINDOW_DEFAULT_W;
            total_wh.h     = 64;
            cells1_offset_x =  0;
            cells1_space_x  =  0;
            cells1_w        = 24;
            cells1_h        = 24;
            cells2_offset_x =  0;
            cells2_space_x  =  0;
            cells2_w        = 24;
            cells2_h        = 24;
            cells3_offset_x =  0;
            cells3_space_x  =  0;
            cells3_w        = 24;
            cells3_h        = 24;
            cells4_offset_x =  0;
            cells4_space_x  =  0;
            cells4_w        = 64;
            cells4_h        = 64;
            order[0] = Order_rec (1,1);
            order[1] = Order_rec (2,2);
            order[2] = Order_rec (3,2);
            order[3] = Order_rec (4,6);
        }
    }
}
