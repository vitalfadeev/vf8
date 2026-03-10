module vf.gui.page;

version (GUI):
import vf.gui.color         : Color;
import vf.gui.layout        : Layout,Line_layout,Lcr_layout;
import vf.std.xywh          : Xy,Wh,Xywh;
import vf.gui.page_.colors  : Colors;
import vf.gui.page_.fonts   : Fonts;
import vf.gui.page_.strings : Strings;
import vf.gui.window        : Window;
import vf.gui.widget        : Widget;
import vf.gui.widget.button : Button;
import vf.gui.widget.volume : Volume;
import std.traits           : EnumMembers;
import vf.sdl.renderer_sdl  : Renderer;
import vf.sdl.importc_sdl;
import std.stdio            : writeln;
import app                  : o;
import hub                  : Hub;
import std.stdio            : writefln;

class
Page {
    Wh         wh;         // ushort x ushort  16368 x 16368
    Colors     colors;
    Fonts      fonts;
    Widget     widget;
    Window     window;

    this (Hub* hub, Page[]* pages) {
        hub.register (this);
        (*pages) ~= /*cast (Page) */this;
        _init ();

    }

    ~this () {
        with (o) {            
            hub.unregister (this);
        }
    }

    void
    _init () {
        style ();
        _init_colors  ();
        _init_fonts   ();
        _init_images  ();
        _init_widgets ();
        _init_window  ();
    }

    void
    _init_window () {
        with (SDL_WindowFlags)
        window.create (
            SDL_WINDOWPOS_CENTERED_DISPLAY (0),SDL_WINDOWPOS_CENTERED_DISPLAY (0), 
            wh.w, wh.h, 
            SDL_WINDOW_RESIZABLE
            | SDL_WINDOW_SHOWN
            // | SDL_WINDOW_VULKAN
            // | SDL_WINDOW_ALLOW_HIGHDPI
            );
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

    void
    _init_widgets () {
        // 
    }

    void
    sdl_mousebuttondown (SDL_MouseButtonEvent* evt) {
        auto xy = Xy (evt.x, evt.y);
        foreach (_widget; widget.recursive) {
            if (_widget.xywh.has (xy)) {
                _widget.sdl_mousebuttondown (evt);
            }
        }
    }

    void
    sdl_mousebuttonup (SDL_MouseButtonEvent* evt) {
        auto xy = Xy (evt.x, evt.y);
        foreach (_widget; widget.recursive)
            if (_widget.xywh.has (xy)) {
                _widget.sdl_mousebuttonup (evt);
            }
    }

    void
    sdl_mousewheel (SDL_MouseWheelEvent* evt) {
        auto xy = Xy (evt.mouseX, evt.mouseY);
        foreach (_widget; widget.recursive)
            if (_widget.xywh.has (xy)) {
                _widget.sdl_mousewheel (evt);
            }
    }

    void
    style () {
        //
    }

    void
    layout () {
        // all widgets recursive
        if (widget !is null) 
        foreach (_widget; widget.recursive)  { // include this.widget
            if (!_widget.childs.empty) 
            if (_widget.childs.layout_dg !is null) 
                _widget.childs.layout_dg (_widget);
        }
    }

    void
    draw () {
        with (o) {
            auto renderer = window.draw_start (true);
            
            foreach (_widget; widget.recursive)
                _widget.draw (renderer);

            window.draw_end (renderer);
        }
    }

    void
    redraw (Widget  wanted_widget) {
        with (o) 
        if (widget.page == this) {
            auto renderer = window.draw_start (false);
            
            foreach (_widget; widget.recursive)
                //if (_widget == wanted_widget)
                _widget.draw (renderer);

            window.draw_end (renderer);
        }
    }
}

