module vf.gui.page;

version (GUI):
version (E_32BIT_PAGED):

import vf.std.tstring256;
import vf.gui.color    : Color;
import vf.gui.layout   : Layout;
import vf.std.xywh     : Xy,Wh,Xywh;
import vf.gui.style    : Style;

import vf.gui.page_.colors  : Colors;
import vf.gui.page_.fonts   : Fonts;
import vf.gui.page_.widgets : Widgets;
import vf.gui.page_.strings : Strings;
import vf.gui.page_.actions : Actions;
import vf.gui.page_.styles  : Styles;
import mod.widget           : Widget;
import mod.widget.button    : Button;
import mod.widget.volume    : Volume;
import std.traits           : EnumMembers;
import vf.sdl.renderer_sdl  : Renderer;
import vf.sdl.importc_sdl   : SDL_Window;
import mod.sdl_wm           : Sdl_wm;
import std.stdio : writeln;
import app : o;
import std.stdio : writefln;

struct
Page {
    Wh           wh;         // ushort x ushort  16368 x 16368
    Layout       layout;     // grid, ...
    Colors       colors;
    Fonts        fonts;
    Widgets      widgets;
    Strings      strings;
    Actions      actions;
    Styles       styles;
    SDL_Window*  window;

    //void
    //do_switch (Event* evt) {
    //    //
    //}

    void
    _init () {
        _init_window  ();
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
    _init_window () {
        window = Sdl_wm.new_window (wh.w, wh.h);
    }

    void
    _init_layout () {
        with (layout.grid) {
            total_wh.w     = wh.w;
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

    TWIDGET*
    create (TWIDGET,ARGS...) (ARGS args) {
        auto twidget = new TWIDGET (args);
        o.hub.register (twidget);
        auto widget = cast (Widget*) twidget;
        widget.name    = TWIDGET.stringof;
        widget.page    = &this;
        widget.draw_dg = &twidget.draw;
        widgets.s ~= widget;
        return twidget;
    }        

    void
    _init_widgets () {
        widgets._init ();
 
        foreach (ubyte i; 0..9) {
            create!Button;
            widgets.s[$-1].flags.enabled = true;
        }        

        create!Volume;
        widgets.s[$-1].flags.enabled = true;

        create!Button;
        widgets.s[$-1].flags.enabled = true;
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

        foreach (widget; widgets.s) {
            styles.s ~= Style (widget.name);
            s = &styles.s[$-1];
            s.flags.enabled = true;

            switch (widget.name) {
                case "Button" /* start  */ : s.font = 1; s.text = 1; s.fg = 2; break;
                case "Volume" /* volume  */ : s.font = 1; s.text = 4; s.fg = 2; break;
                //case 3 /* batary */ : s.font = 1; s.text = 3; s.fg = 2; break;
                //case 4 /* volume */ : s.font = 1; s.text = 4; s.fg = 2; break;
                //case 5 /* avia   */ : s.font = 1; s.text = 5; s.fg = 2; break;
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

    void
    _layout () {
        import std.range : lockstep;

        // all widgets
        foreach (widget,xywh; lockstep (widgets.s, layout.range)) {
            widget.xywh = xywh;  // cache xywh
        }
    }

    void
    draw (Renderer* renderer) {
        writeln ("PAGE DRAW");
        foreach (widget; widgets.s) {
            auto style = styles.get_style (widget);
            style.get.fg   = colors.s[style.fg];
            style.get.bg   = colors.s[style.bg];
            style.get.text = strings.s[style.text];
            style.get.font = fonts.s[style.font];

            widget.draw_dg (style, renderer);
        }
    }

    void
    redraw (Widget* widget) {
        writeln ("PAGE REDRAW");
        with (o) {
            auto style = styles.get_style (widget);
            style.get.fg   = colors.s[style.fg];
            style.get.bg   = colors.s[style.bg];
            style.get.text = strings.s[style.text];
            style.get.font = fonts.s[style.font];

            Renderer renderer;
            renderer.draw_start (window);
            draw (&renderer);
            renderer.draw_end (window);
        }
    }
}
