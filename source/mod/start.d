module mod.start;

version (GUI):
import vf.gui.widget        : Widget;
import vf.gui.widget.button : Button;
import vf.gui.widget.volume : Volume;
import vf.gui.widget.check  : Check;
import vf.gui.widget.slider : Slider;
import vf.gui.color         : Color;
import vf.gui.layout;
import vf.std.xywh          : Xy,Wh,Xywh;
import vf.gui.page          : Page;
import vf.sdl.importc_sdl;
import vf.sdl.window_flags;
import app                  : o;
import hub                  : Hub;

enum W = 1366;
enum H = 48;
enum S1 = 48;

struct
Start {
    Page_start page;

    void
    START () {
        // Page_qs
        // window
        with (o) {
            page = new Page_start (&hub,&pages);
        }
    }
}


class
Page_start : Page {
    this (Hub* hub, Page[]* pages) {
        super (hub,pages);
    }

    override
    void
    _init () {
        style ();
        _init_colors  ();
        _init_fonts   ();
        _init_images  ();
        _init_widgets ();
        _init_window  ();
        layout ();
    }

    override
    void
    _init_widgets () {
        widget = create_ui (&o.hub, /*cast (Page)*/ this);
    }

    override
    void
    _init_window () {
        import mod.sdl_wm;

        // for get mouse click on noactive window
        SDL_SetHint (cast (const(char)*) SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "1");

        with (o)
        window.create (
            0,0, 
            wh.w, wh.h, 
            SDL_WINDOW_BORDERLESS
            | SDL_WINDOW_ALWAYS_ON_TOP
            | SDL_WINDOW_UTILITY
            // | SDL_WINDOW_VULKAN
            // | SDL_WINDOW_ALLOW_HIGHDPI
            );
    }

    override
    void
    style () {
        wh.w = W;
        wh.h = H;
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

Widget
create_ui (Hub* hub, Page page) {
    // main
    auto main = new Main (page);
    main.xywh.w = W;
    main.xywh.h = S1;
    main.childs.layout_dg = &(new Lcr_layout (S1)).layout;

    // layout
    auto left = new Left (page);
    left.xywh.w = S1*1;
    left.xywh.h = S1;
    left.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (left);

    auto center = new Center (page);
    center.xywh.w = S1*1;
    center.xywh.h = S1;
    center.xywh.x = W/2 - S1*1/2;
    center.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (center);

    auto right = new Right (page);
    right.xywh.w = S1*4;
    right.xywh.h = S1;
    right.xywh.x = W - S1*4;
    right.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (right);

    // buttons
    auto start = new Start_ (page);
    start.xywh.w = S1;
    start.xywh.h = S1;
    left.childs.put (start);

    auto clock = new Clock (page);
    clock.xywh.w = S1;
    clock.xywh.h = S1;
    center.childs.put (clock);

    auto lan = new Lan (page);
    lan.xywh.w = S1;
    lan.xywh.h = S1;
    right.childs.put (lan);

    auto wifi = new Wifi (page);
    wifi.xywh.w = S1;
    wifi.xywh.h = S1;
    right.childs.put (wifi);

    auto volume = new Volume_ (page);
    volume.xywh.w = S1;
    volume.xywh.h = S1;
    right.childs.put (volume);

    auto battery = new Battery (page);
    battery.xywh.w = S1;
    battery.xywh.h = S1;
    right.childs.put (battery);

    //
    return /*cast (Widget)*/ main;
}

//
class
Main : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Left : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Center : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Right : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

//
class
Start_ : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Clock : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Lan : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Wifi : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Volume_ : Volume {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        

    override
    void
    pressed () {
        with (o)
        hub.QUICK_SETTINGS ();
    }
}

class
Battery : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}
