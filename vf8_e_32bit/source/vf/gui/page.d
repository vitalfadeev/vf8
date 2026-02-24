module vf.gui.page;

version (GUI):
version (E_32BIT_PAGED):

import vf.std.tstring256;
import vf.gui.color    : Color;
import vf.gui.layout   : Layout;
import vf.std.xywh     : XY,WH,XYWH;
import vf.gui.e        : E;

import vf.gui.page_.colors  : Colors;
import vf.gui.page_.fonts   : Fonts;
import vf.gui.page_.widgets : Widgets;
import vf.gui.page_.strings : Strings;
import vf.gui.page_.actions : Actions;
import vf.gui.page_.styles  : Styles;


struct
Page {
    Tstring256!E es;
    WH           wh;         // ushort x ushort  16368 x 16368
    Layout       layout;  // grid, ...
    pragma (msg, "es.size: ", es.sizeof);  // 1028

    Colors      colors;
    Fonts       fonts;
    Widgets     widgets;
    Strings     strings;
    Actions     actions;
    Styles      styles;

    void
    _init () {
        _init_colors  ();
        _init_fonts   ();
        _init_icons   ();
        _init_es      ();
        _init_strings ();
        _init_widgets ();
        version (ACTIONS) _init_actions ();
        _init_styles  ();
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
    }

    void
    _init_icons () {
        //
    }

    void
    _init_es () {
        es[0].type  = 1; // start 
        es[1].type  = 0;
        es[2].type  = 0;
        es[3].type  = 0;
        es[4].type  = 0;
        es[5].type  = 2; // clock
        es[6].type  = 0;
        es[7].type  = 0;
        es[8].type  = 3; // indicators
        es[9].type  = 4; // indicators
        es[10].type = 5; // indicators
    }

    void
    _init_strings () {
        strings._init ();
    }

    void
    _init_widgets () {
        widgets._init ();
    }

    version (ACTIONS)
    void
    _init_actions () {
        import actions.quit : Quit;
        import actions.quit : SDL_MOUSEBUTTONDOWN;
        actions._init ();
        actions.register (Quit.stringof, new Quit);
        actions.register (SDL_MOUSEBUTTONDOWN.stringof, new SDL_MOUSEBUTTONDOWN);
    }

    void
    _init_styles () {
        styles._init ();
    }
}
