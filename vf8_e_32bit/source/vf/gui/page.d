module vf.gui.page;

version (GUI):
version (E_32BIT_PAGED):

import vf.std.tstring256;
import vf.gui.color    : Color;
import vf.gui.layout   : Layout,Line_layout,Lcr_layout;
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
        foreach (_widget; widget.recursive)  { // include this.widget
            if (!_widget.childs.empty) 
            if (_widget.childs.layout_dg !is null) 
                _widget.childs.layout_dg (_widget);
        }
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
//                if (_widget == wanted_widget)
                    _widget.draw_dg (&renderer);
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
    main.xywh.w = 1024;
    main.xywh.h = 64;
    main.childs.layout_dg = &(new Lcr_layout).layout;

    // layout
    auto left = page.create!Left ();
    left.xywh.w = 64*1;
    left.xywh.h = 64;
    left.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (left);

    auto center = page.create!Center ();
    center.xywh.w = 64*1;
    center.xywh.h = 64;
    center.xywh.x = 1024/2 - 64*1/2;
    center.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (center);

    auto right = page.create!Right ();
    right.xywh.w = 64*4;
    right.xywh.h = 64;
    right.xywh.x = 1024 - 64*4;
    right.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (right);

    // buttons
    auto start = page.create!Start ();
    start.xywh.w = 64;
    start.xywh.h = 64;
    left.childs.put (start);

    auto clock = page.create!Clock ();
    clock.xywh.w = 64;
    clock.xywh.h = 64;
    center.childs.put (clock);

    auto lan = page.create!Lan ();
    lan.xywh.w = 64;
    lan.xywh.h = 64;
    right.childs.put (lan);

    auto wifi = page.create!Wifi ();
    wifi.xywh.w = 64;
    wifi.xywh.h = 64;
    right.childs.put (wifi);

    auto volume = page.create!Volume_ ();
    volume.xywh.w = 64;
    volume.xywh.h = 64;
    right.childs.put (volume);

    auto battery = page.create!Battery ();
    battery.xywh.w = 64;
    battery.xywh.h = 64;
    right.childs.put (battery);

    //
    page.widget = cast (Widget*) main;
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
    Button _super;
    alias _super this;    
}

struct
Lan {
    Button _super;
    alias _super this;    
}

struct
Wifi {
    Button _super;
    alias _super this;    
}

struct
Volume_ {
    Button _super;
    alias _super this;    
}

struct
Battery {
    Button _super;
    alias _super this;    
}
