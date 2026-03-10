module mod.quick_settings;

import vf.gui.widget        : Widget,_Widget;
import vf.gui.widget.button : Button;
import vf.gui.widget.check  : Check;
import vf.gui.widget.slider : Slider;
import vf.gui.color         : Color;
import vf.gui.layout;
import vf.std.xywh          : Xy,Wh,Xywh;
import vf.gui.page          : Page,_Page;
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
    void
    QUICK_SETTINGS () {
        // Page_qs
        // window
        with (o) {
            auto page = new Page_qs (&hub,&pages);
        }
    }
}

struct
Page_qs {
    mixin _Page;

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

    void
    _init_window () {
        import mod.sdl_wm;
        with (o)
        window.create (wh.w, wh.h);
    }

    void
    _init_widgets () {
        widget = create_ui (&o.hub, cast (Page*) &this);
    }

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
Widget*
create_ui (Hub* hub, Page* page) {
    // main
    auto main = new Main (hub,page);
    main.xywh.w = W;
    main.xywh.h = S1;
    main.childs.layout_dg = &(new Column_layout).layout;

    // layout
    // line 1
    auto left_right = new Left_right (hub,page);
    left_right.xywh.w = W;
    left_right.xywh.h = S1;
    left_right.childs.layout_dg = &(new Lr_layout (S1)).layout;
    main.childs.put (left_right);

    // line 1, pos 1
    auto _1 = new L1 (hub,page);
    _1.xywh.w = S1*1;
    _1.xywh.h = S1;
    _1.childs.layout_dg = &(new Line_layout).layout;
    left_right.childs.put (_1);

    // line 1, pos 2
    auto _2 = new L2 (hub,page);
    _2.xywh.w = S1*4;
    _2.xywh.h = S1;
    _2.xywh.x = W - S1*4;
    _2.childs.layout_dg = &(new Line_layout).layout;
    left_right.childs.put (_2);

    // line 2-3, pos 3
    auto _3 = new L3 (hub,page);
    _3.xywh.w = W;
    _3.xywh.h = S3*2;
    _3.childs.layout_dg = &(new Column_layout).layout;
    main.childs.put (_3);

    // line 4, pos 4
    auto _4 = new L4 (hub,page);
    _4.xywh.w = W;
    _4.xywh.h = S4*2;
    _4.childs.layout_dg = &(new Grid_layout_ (2,2)).layout;
    main.childs.put (_4);

    // buttons
    // 1-2
    auto battery = new Battery (hub,page);
    battery.xywh.w = S1;
    battery.xywh.h = S1;
    _1.childs.put (battery);

    auto screenshot = new Screenshot (hub,page);
    screenshot.xywh.w = S1;
    screenshot.xywh.h = S1;
    _2.childs.put (screenshot);

    auto settings = new Settings (hub,page);
    settings.xywh.w = S1;
    settings.xywh.h = S1;
    _2.childs.put (settings);

    auto lock = new Lock (hub,page);
    lock.xywh.w = S1;
    lock.xywh.h = S1;
    _2.childs.put (lock);

    auto quit = new Quit (hub,page);
    quit.xywh.w = S1;
    quit.xywh.h = S1;
    _2.childs.put (quit);

    // 3
    auto volume = new Volume__ (hub,page);
    volume.xywh.w = W;
    volume.xywh.h = S3;
    _3.childs.put (volume);

    auto bright = new Bright (hub,page);
    bright.xywh.w = W;
    bright.xywh.h = S3;
    _3.childs.put (bright);

    // 4 
    auto lan = new Lan (hub,page);
    lan.xywh.w = W/2;
    lan.xywh.h = S4;
    _4.childs.put (lan);

    auto wifi = new Wifi (hub,page);
    wifi.xywh.w = W/2;
    wifi.xywh.h = S4;
    _4.childs.put (wifi);

    auto power = new Power (hub,page);
    power.xywh.w = W/2;
    power.xywh.h = S4;
    _4.childs.put (power);

    auto avia = new Avia (hub,page);
    avia.xywh.w = W/2;
    avia.xywh.h = S4;
    _4.childs.put (avia);

    //
    return cast (Widget*) main;
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
    mixin _Widget;
}

struct
Left_right {
    mixin _Widget;
}

struct
L1 {
    mixin _Widget;
}

struct
L2 {
    mixin _Widget;
}

struct
L3 {
    mixin _Widget;
}

struct
L4 {
    mixin _Widget;
}

struct
Battery {
    mixin _Widget!Button;
}

struct
Screenshot {
    mixin _Widget!Button;
}

struct
Settings {
    mixin _Widget!Button;
}

struct
Lock {
    mixin _Widget!Button;
}

struct
Quit {
    mixin _Widget!Button;
}

struct
Volume__ {
    mixin _Widget!Slider;
}

struct
Bright {
    mixin _Widget!Slider;
}

struct
Lan {
    mixin _Widget!Check;
}

struct
Wifi {
    mixin _Widget!Check;
}

struct
Power {
    mixin _Widget!Check;
}

struct
Avia {
    mixin _Widget!Check;
}
