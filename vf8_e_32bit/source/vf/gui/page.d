module vf.gui.page;

version (GUI):
version (E_32BIT_PAGED):

import vf.std.tstring256;
import vf.gui.color    : Color;
import vf.gui.layout   : Layout;
import vf.std.xywh     : XY,WH,XYWH;
import vf.gui.style    : Style;
import vf.sdl.window   : Window;

import vf.gui.page_.colors  : Colors;
import vf.gui.page_.fonts   : Fonts;
import vf.gui.page_.widgets : Widgets;
import vf.gui.page_.strings : Strings;
import vf.gui.page_.actions : Actions;
import vf.gui.page_.styles  : Styles;
import mod.widget           : Widget;
import std.traits           : EnumMembers;


struct
Page {
    WH           wh;         // ushort x ushort  16368 x 16368
    Layout       layout;     // grid, ...
    Colors       colors;
    Fonts        fonts;
    Widgets      widgets;
    Strings      strings;
    Actions      actions;
    Styles       styles;
    Window*      window;

    //void
    //do_switch (Event* evt) {
    //    //
    //}

    void
    _init () {
        _init_colors  ();
        _init_fonts   ();
        _init_icons   ();
        _init_strings ();
        _init_widgets ();
        version (ACTIONS) _init_actions ();
        _init_styles  ();
        _init_layout  ();
    }

    void
    _init_layout () {
        with (layout.grid) {
            import vf.sdl.window : WINDOW_DEFAULT_W, WINDOW_DEFAULT_H;
            total_wh.w     = WINDOW_DEFAULT_W;
            total_wh.h     = 64;
            cells_offset_x =  0;
            cells_space_x  =  0;
            cells_w        = 64;
            cells_h        = 64;
            first_cell_w   = 64;
            first_cell_h   = 64;
            order[0] = Order_rec (1,3);
            order[1] = Order_rec (2,2);
            order[2] = Order_rec (3,1);
            order[3] = Order_rec (4,2);
            order[4] = Order_rec (5,3);
        }
    }

    void
    _init_colors () {
        colors.s[0] = 0xFF000000;  // dark
        colors.s[1] = 0xFF444444;  // base
        colors.s[2] = 0xFF888888;  // base-1
        colors.s[3] = 0xFFCCCCCC;  // base-2
        colors.s[4] = 0xFF883333;  
        colors.s[5] = 0xFFFFFFFF;  
    }

    void
    _init_fonts () {
        fonts._init ();
        //font[0] = open_font ("NotoSansMNerd-Regular", 64);
        //font[1] = open_font ("NotoSansMNerd-Regular", 32);
        //font[2] = open_font ("NotoSansMNerd-Regular", 16);
        fonts.s[0] = fonts._open_font ("res/NotoMonoNerdFont-Regular.ttf", 64);
        fonts.s[1] = fonts._open_font ("res/NotoMonoNerdFont-Regular.ttf", 32);
        fonts.s[2] = fonts._open_font ("res/NotoMonoNerdFont-Regular.ttf", 16);
    }

    void
    _init_icons () {
        //
    }

    void
    _init_strings () {
        strings._init ();
        strings.s[0] = "    ";
        strings.s[1] = "";
        strings.s[2] = "";
        strings.s[3] = "󰁹󰁹󰁹󰁹";
        strings.s[4] = "";  // //        󰕾 󰕿 󰖀 󰝞 󰝟 󰖁 󰝝 󱄠 󱄡
        strings.s[5] = "󰀝󰀝󰀝󰀝";
    }

    void
    _init_widgets () {
        widgets._init ();
 
        foreach (ubyte i; 0..12)
            widgets.s[i].flags.enabled = true;
        
        widgets.s[0].type  = Widget.Type.BUTTON; // start 
        widgets.s[1].type  = Widget.Type._;
        widgets.s[2].type  = Widget.Type._;
        widgets.s[3].type  = Widget.Type._;
        widgets.s[4].type  = Widget.Type._;
        widgets.s[5].type  = Widget.Type.BUTTON; // clock
        widgets.s[6].type  = Widget.Type._;
        widgets.s[7].type  = Widget.Type._;
        widgets.s[8].type  = Widget.Type.BUTTON; // indicators
        widgets.s[9].type  = Widget.Type.BUTTON; // indicators
        widgets.s[10].type = Widget.Type.BUTTON; // indicators
        widgets.s.length = 12;
    }

    version (ACTIONS)
    void
    _init_actions () {
        import actions.quit : Quit;
        import actions.quit : SDL_MOUSEBUTTONDOWN;
        import actions.quit : SHOW_QUICK_SETTINGS;
        actions._init ();
        actions.register (Quit.stringof, new Quit);
        actions.register (SDL_MOUSEBUTTONDOWN.stringof, new SDL_MOUSEBUTTONDOWN);
        actions.register (SHOW_QUICK_SETTINGS.stringof, new SHOW_QUICK_SETTINGS);
    }

    void
    _init_styles () {
        styles._init ();

        Style* s = &styles.s[0];
        Style* s2 = &styles.s[0];
        s.fg   = 1;
        s.font = 1;

        foreach (Widget.Type t; EnumMembers!(Widget.Type)) {
            styles.s ~= Style (t);
            s = &styles.s[$-1];
            s.flags.enabled = true;

            switch (t) with (Widget.Type) {
                case 1 /* start  */ : s.font = 1; s.text = 1; s.fg = 2; break;
                case 2 /* clock  */ : s.font = 2; s.text = 2; s.fg = 2; break;
                case 3 /* batary */ : s.font = 1; s.text = 3; s.fg = 2; break;
                case 4 /* volume */ : s.font = 1; s.text = 4; s.fg = 2; break;
                case 5 /* avia   */ : s.font = 1; s.text = 5; s.fg = 2; break;
                default:
           }

            // base 
            styles.s ~= *s;
            s2 = &styles.s[$-1];
            s2.fg = 3; 
            s2.bg = 1;
            // pressed
            styles.s ~= *s;
            s2 = &styles.s[$-1];
            s2.flags.pressed = true;
            s2.fg = 5; 
            s2.bg = 2;
        }

        // disabled pressed selected focused m_over lamp_on
        // 16
        // type * 16  // base, button, check, radio, select, text
        // 6*16 = 96 styles * 10 = 960 Bytes
        //
        // max
        // 256 types * 6 flags = 1536 * 10 = 15_360 Bytes
        // 256 types * 2^6 flags = 256*64 = 16384 *10 = 163_840 Bytes
    }
}
