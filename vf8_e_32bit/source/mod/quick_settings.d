module mod.quick_settings;

import mod.widget        : Widget;
import mod.widget.button : Button;
import vf.gui.color    : Color;
import vf.gui.layout;
import vf.std.xywh     : Xy,Wh,Xywh;
import vf.gui.page       : Page;
import app : o;


struct
Quick_settings {
    void
    QUICK_SETTINGS () {
        // Page_qs
        // window
        with (o) {
            auto page = new Page_qs ();
            page.wh.w = 320;
            page.wh.h = 600;
            page.draw_dg = &page.draw;
            hub.register (page);
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
        this.layout ();
    }

    void
    _init_window () {
        import mod.sdl_wm;
        with (o)
        window.create (wh.w, wh.h);
    }

    void
    _init_widgets () {
        create_ui (&this);
    }

    void
    style () {
        wh.w = 320;
        wh.h = 600;
    }
}

// 1   2 2 2  // left right
// 3 -------  //
// 3 -------  //
// 4--- ---4  //
// 4--- ---4  //
// 4--- ---4  //
void
create_ui (Page_qs* page) {
    // main
    auto main = page.create!Main ();
    main.xywh.w = 1024;
    main.xywh.h = 64;
    main.childs.layout_dg = &(new Column_layout).layout;

    // layout
    // line 1
    auto left_right = page.create!Left_right ();
    left_right.xywh.w = 64*1;
    left_right.xywh.h = 64;
    left_right.childs.layout_dg = &(new Lr_layout).layout;
    main.childs.put (left_right);

    // line 1, pos 1
    auto _1 = page.create!L1 ();
    _1.xywh.w = 64*4;
    _1.xywh.h = 64;
    _1.xywh.x = 1024 - 64*4;
    _1.childs.layout_dg = &(new Line_layout).layout;
    left_right.childs.put (_1);

    // line 1, pos 2
    auto _2 = page.create!L2 ();
    _2.xywh.w = 64*4;
    _2.xywh.h = 64;
    _2.xywh.x = 1024 - 64*4;
    _2.childs.layout_dg = &(new Line_layout).layout;
    left_right.childs.put (_2);

    // line 2-3, pos 3
    auto _3 = page.create!L3 ();
    _3.xywh.w = 64*4;
    _3.xywh.h = 64;
    _3.xywh.x = 1024 - 64*4;
    _3.childs.layout_dg = &(new Column_layout).layout;
    main.childs.put (_3);

    // line 4, pos 4
    auto _4 = page.create!L4 ();
    _4.xywh.w = 64*4;
    _4.xywh.h = 64;
    _4.xywh.x = 1024 - 64*4;
    _4.childs.layout_dg = &(new Grid_layout_ (2,2)).layout;
    main.childs.put (_4);

    // buttons
    // 1-2
    auto battery = page.create!Battery ();
    battery.xywh.w = 32;
    battery.xywh.h = 32;
    _1.childs.put (battery);

    auto screenshot = page.create!Screenshot ();
    screenshot.xywh.w = 32;
    screenshot.xywh.h = 32;
    _2.childs.put (screenshot);

    auto settings = page.create!Settings ();
    settings.xywh.w = 32;
    settings.xywh.h = 32;
    _2.childs.put (settings);

    auto lock = page.create!Lock ();
    lock.xywh.w = 32;
    lock.xywh.h = 32;
    _2.childs.put (lock);

    auto quit = page.create!Quit ();
    quit.xywh.w = 32;
    quit.xywh.h = 32;
    _2.childs.put (quit);

    // 3
    auto volume = page.create!Volume__ ();
    volume.xywh.w = 32;
    volume.xywh.h = 32;
    _3.childs.put (volume);

    auto bright = page.create!Bright ();
    bright.xywh.w = 32;
    bright.xywh.h = 32;
    _3.childs.put (bright);

    // 4 
    auto lan = page.create!Lan ();
    lan.xywh.w = 64;
    lan.xywh.h = 64;
    _4.childs.put (lan);

    auto wifi = page.create!Wifi ();
    wifi.xywh.w = 64;
    wifi.xywh.h = 64;
    _4.childs.put (wifi);

    auto power = page.create!Power ();
    power.xywh.w = 64;
    power.xywh.h = 64;
    _4.childs.put (power);

    _new!Avia (page, 64, 64, _4);

    //
    page.widget = cast (Widget*) main;
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
struct
Main {
    Widget _super;
    alias _super this;    
}

struct
Left_right {
    Widget _super;
    alias _super this;    
}

struct
L1 {
    Widget _super;
    alias _super this;    
}

struct
L2 {
    Widget _super;
    alias _super this;    
}

struct
L3 {
    Widget _super;
    alias _super this;    
}

struct
L4 {
    Widget _super;
    alias _super this;    
}

struct
Battery {
    Button _super;
    alias _super this;   
}

struct
Screenshot {
    Button _super;
    alias _super this;   
}

struct
Settings {
    Button _super;
    alias _super this;   
}

struct
Lock {
    Button _super;
    alias _super this;   
}

struct
Quit {
    Button _super;
    alias _super this;   
}

struct
Volume__ {
    Slider _super;
    alias _super this;   
}

struct
Bright {
    Slider _super;
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
Power {
    Button _super;
    alias _super this;   
}

struct
Avia {
    Button _super;
    alias _super this;   
}

//
struct
Slider {
    Widget _super;
    alias _super this;   
}
