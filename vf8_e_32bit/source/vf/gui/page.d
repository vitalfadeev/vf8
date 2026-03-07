module vf.gui.page;

version (GUI):
version (E_32BIT_PAGED):

import vf.std.tstring256;
import vf.gui.color    : Color;
import vf.gui.layout   : Layout;
import vf.std.xywh     : Xy,Wh,Xywh;

import vf.gui.page_.colors  : Colors;
import vf.gui.page_.fonts   : Fonts;
import vf.gui.page_.strings : Strings;
import mod.widget           : Widget;
import mod.widget.button    : Button;
import mod.widget.volume    : Volume;
import std.traits           : EnumMembers;
import vf.sdl.renderer_sdl  : Renderer;
import vf.sdl.importc_sdl   : SDL_Window;
import std.stdio : writeln;
import app : o;
import std.stdio : writefln;

struct
Page {
    Wh           wh;         // ushort x ushort  16368 x 16368
    Colors       colors;
    Fonts        fonts;
    Widget*      widget;
    SDL_Window*  window;
    //Xy           window_xy;

    //void
    //do_switch (Event* evt) {
    //    //
    //}

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
    _init_images () {
        //
    }

    TWIDGET*
    create (TWIDGET,ARGS...) (ARGS args) {
        auto twidget = new TWIDGET (args);
        o.hub.register (twidget);
        auto widget = cast (Widget*) twidget;
        widget.page    = &this;
        static if (__traits(hasMember,TWIDGET,"style"))
            widget.style_dg = &__traits(getMember,twidget,"style");
        static if (__traits(hasMember,TWIDGET,"draw"))
            widget.draw_dg  = &__traits(getMember,twidget,"draw");
        widget.xywh.w = 64;
        widget.xywh.h = 64;
        widget.name   = TWIDGET.stringof;
        return twidget;
    }        

    void
    _init_widgets () {
        create_ui (&this);
    }

    void
    style () {
        wh.w = 1024;
        wh.h = 600;
    }

    void
    LAYOUT () {
        // all widgets recursive
        if (widget !is null) 
        if (!widget.childs.empty) 
        if (widget.childs.layout_dg !is null) 
            widget.childs.layout_dg (widget);
    }

    void
    draw (Renderer* renderer) {
        with (o) {
            renderer.draw_start (window,true);
            foreach (_widget; widget.recursive)
                writeln (_widget.name);
            foreach (_widget; widget.recursive)
                if (_widget.draw_dg !is null)
                    _widget.draw_dg (renderer);
            renderer.draw_end (window);
        }
    }

    void
    REDRAW (Widget* wanted_widget) {
        with (o) 
        if (widget.page == &this) {
            Renderer renderer;
            renderer.draw_start (window,false);
            foreach (_widget; widget.recursive)
                if (_widget == wanted_widget)
                    _widget.draw (&renderer);
            renderer.draw_end (window);
        }
    }
}

// w main
//   w left
//     w start
//   w center
//     w clock
//   w right
//     w lan
//     w wifi
//     w volume
//     w battery

void
create_ui (Page* page) {
    // main
    auto main = page.create!Main ();

    // layout
    auto left = page.create!Left ();
    main.childs.put (left);

    auto center = page.create!Center ();
    main.childs.put (center);

    auto right = page.create!Right ();
    main.childs.put (right);

    // buttons
    auto start = page.create!Start ();
    left.childs.put (start);

    auto clock = page.create!Clock ();
    center.childs.put (clock);

    auto lan = page.create!Lan ();
    right.childs.put (lan);

    auto wifi = page.create!Wifi ();
    right.childs.put (wifi);

    auto volume = page.create!Volume_ ();
    right.childs.put (volume);

    auto battery = page.create!Battery ();
    right.childs.put (battery);

    // layout
    Layout layout;
    _init_layout (&layout, page.wh);

    //
    page.widget = cast (Widget*) main;
}
void
_init_layout (Layout* layout, Wh wh) {
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

//
struct
Main {
    Widget _super;
    alias _super this;    
}

struct
Left {
    Widget _super;
    alias _super this;    
}

struct
Center {
    Widget _super;
    alias _super this;    
}

struct
Right {
    Widget _super;
    alias _super this;    
}

//
struct
Start {
    Button _super;
    alias _super this;    
}

struct
Clock {
    Widget _super;
    alias _super this;    
}

struct
Lan {
    Widget _super;
    alias _super this;    
}

struct
Wifi {
    Widget _super;
    alias _super this;    
}

struct
Volume_ {
    Widget _super;
    alias _super this;    
}

struct
Battery {
    Widget _super;
    alias _super this;    
}
