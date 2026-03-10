module mod.quick_settings;

version (GUI):
import vf.gui.widget        : Widget;
import vf.gui.widget.button : Button;
import vf.gui.widget.check  : Check;
import vf.gui.widget.slider : Slider;
import vf.gui.color         : Color;
import vf.gui.layout;
import vf.std.xywh          : Xy,Wh,Xywh;
import vf.gui.page          : Page;
import vf.sdl.importc_sdl;
import app                  : o;
import hub                  : Hub;

enum W = 1024/2;
enum H = 600;
enum S1 = 48;
enum S2 = S1;
enum S3 = 48;
enum S4 = 64;


struct
Quick_settings {
    Page_qs page;
    bool    opened;

    void
    QUICK_SETTINGS () {
        // Page_qs
        // window
        with (o) {
            if (!opened) {
                page = new Page_qs (&hub,&pages,&this);
                opened = true;
            }
            else {
                SDL_DestroyWindow (page.window._sdl_window);
                opened = false;
            }
        }
    }
}

class
Page_qs : Page {
    Quick_settings* mod_qs;

    this (Hub* hub, Page[]* pages, Quick_settings* mod_qs) {
        this.mod_qs = mod_qs;
        super (hub,pages);
    }

    ~this () {
        mod_qs.opened = false;
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
    _init_window () {
        import mod.sdl_wm;
        with (o)
        with (SDL_WindowFlags)
        window.create (
            1366-wh.w, 48, 
            wh.w, wh.h, 
            SDL_WINDOW_BORDERLESS
            | SDL_WINDOW_ALWAYS_ON_TOP
            | SDL_WINDOW_SKIP_TASKBAR
            | SDL_WINDOW_SHOWN
            // | SDL_WINDOW_VULKAN
            // | SDL_WINDOW_ALLOW_HIGHDPI
            );
    }

    override
    void
    _init_widgets () {
        widget = create_ui (&o.hub, /*cast (Page)*/ this);
    }

    override
    void
    style () {
        wh.w = W;
        wh.h = H;
    }
}

// 1   2 2 2  // left right
// 3 -------  //
// 3 -------  //
// 4--- ---4  //
// 4--- ---4  //
// 4--- ---4  //
Widget
create_ui (Hub* hub, Page page) {
    // main
    auto main = new Main (page);
    main.xywh.w = W;
    main.xywh.h = S1;
    main.childs.layout_dg = &(new Column_layout).layout;

    // layout
    // line 1
    auto left_right = new Left_right (page);
    left_right.xywh.w = W;
    left_right.xywh.h = S1;
    left_right.childs.layout_dg = &(new Lr_layout (S1)).layout;
    main.childs.put (left_right);

    // line 1, pos 1
    auto _1 = new L1 (page);
    _1.xywh.w = S1*1;
    _1.xywh.h = S1;
    _1.childs.layout_dg = &(new Line_layout).layout;
    left_right.childs.put (_1);

    // line 1, pos 2
    auto _2 = new L2 (page);
    _2.xywh.w = S1*4;
    _2.xywh.h = S1;
    _2.xywh.x = W - S1*4;
    _2.childs.layout_dg = &(new Line_layout).layout;
    left_right.childs.put (_2);

    // line 2-3, pos 3
    auto _3 = new L3 (page);
    _3.xywh.w = W;
    _3.xywh.h = S3*2;
    _3.childs.layout_dg = &(new Column_layout).layout;
    main.childs.put (_3);

    // line 4, pos 4
    auto _4 = new L4 (page);
    _4.xywh.w = W;
    _4.xywh.h = S4*2;
    _4.childs.layout_dg = &(new Grid_layout_ (2,2)).layout;
    main.childs.put (_4);

    // buttons
    // 1-2
    auto battery = new Battery (page);
    battery.xywh.w = S1;
    battery.xywh.h = S1;
    _1.childs.put (battery);

    auto screenshot = new Screenshot (page);
    screenshot.xywh.w = S1;
    screenshot.xywh.h = S1;
    _2.childs.put (screenshot);

    auto settings = new Settings (page);
    settings.xywh.w = S1;
    settings.xywh.h = S1;
    _2.childs.put (settings);

    auto lock = new Lock (page);
    lock.xywh.w = S1;
    lock.xywh.h = S1;
    _2.childs.put (lock);

    auto quit = new Quit (page);
    quit.xywh.w = S1;
    quit.xywh.h = S1;
    _2.childs.put (quit);

    // 3
    auto volume = new Volume__ (page);
    volume.xywh.w = W;
    volume.xywh.h = S3;
    _3.childs.put (volume);

    auto bright = new Bright (page);
    bright.xywh.w = W;
    bright.xywh.h = S3;
    _3.childs.put (bright);

    // 4 
    auto lan = new Lan (page);
    lan.xywh.w = W/2;
    lan.xywh.h = S4;
    _4.childs.put (lan);

    auto wifi = new Wifi (page);
    wifi.xywh.w = W/2;
    wifi.xywh.h = S4;
    _4.childs.put (wifi);

    auto power = new Power (page);
    power.xywh.w = W/2;
    power.xywh.h = S4;
    _4.childs.put (power);

    auto avia = new Avia (page);
    avia.xywh.w = W/2;
    avia.xywh.h = S4;
    _4.childs.put (avia);

    //
    return /*cast (Widget) */main;
}

pragma (inline, true)
void
_new (TWIDGET,Page,Loca) (Page* page, int w, int h, Loca* loca) { 
    auto _widget = page.create!TWIDGET ();
    _widget.xywh.w = w;
    _widget.xywh.h = h;
    loca.childs.put (_widget);
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
Left_right : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
L1 : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
L2 : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
L3 : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
L4 : Widget {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

//
class
Battery : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Screenshot : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Settings : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Lock : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Quit : Button {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Volume__ : Slider {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Bright : Slider {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Lan : Check {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Wifi : Check {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Power : Check {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}

class
Avia : Check {
    this (Page page) {
        super (page);
        o.hub.register (this);
    }        
}
