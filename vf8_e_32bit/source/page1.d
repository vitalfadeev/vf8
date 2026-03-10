module page1;

version (GUI):
import vf.gui.color         : Color;
import vf.gui.layout        : Layout,Line_layout,Lcr_layout;
import vf.std.xywh          : Xy,Wh,Xywh;
import vf.gui.page_.colors  : Colors;
import vf.gui.page_.fonts   : Fonts;
import vf.gui.page_.strings : Strings;
import vf.gui.window        : Window;
import vf.gui.widget        : Widget,_Widget;
import vf.gui.widget.button : Button;
import vf.gui.widget.volume : Volume;
import vf.gui.page          : Page,_Page;
import std.traits           : EnumMembers;
import vf.sdl.renderer_sdl  : Renderer;
import vf.sdl.importc_sdl   : SDL_MouseButtonEvent,SDL_MouseWheelEvent;
import std.stdio            : writeln;
import app                  : o;
import hub                  : Hub;
import std.stdio            : writefln;

enum W = 1024;
enum H = 600;
enum S1 = 48;

struct
Page1 {
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
    _init_widgets () {
        widget = create_ui (&o.hub, cast (Page*) &this);
    }

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

Widget*
create_ui (Hub* hub, Page* page) {
    // main
    auto main = new Main (hub,page);
    main.xywh.w = W;
    main.xywh.h = S1;
    main.childs.layout_dg = &(new Lcr_layout (S1)).layout;

    // layout
    auto left = new Left (hub,page);
    left.xywh.w = S1*1;
    left.xywh.h = S1;
    left.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (left);

    auto center = new Center (hub,page);
    center.xywh.w = S1*1;
    center.xywh.h = S1;
    center.xywh.x = W/2 - S1*1/2;
    center.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (center);

    auto right = new Right (hub,page);
    right.xywh.w = S1*4;
    right.xywh.h = S1;
    right.xywh.x = W - S1*4;
    right.childs.layout_dg = &(new Line_layout).layout;
    main.childs.put (right);

    // buttons
    auto start = new Start (hub,page);
    start.xywh.w = S1;
    start.xywh.h = S1;
    left.childs.put (start);

    auto clock = new Clock (hub,page);
    clock.xywh.w = S1;
    clock.xywh.h = S1;
    center.childs.put (clock);

    auto lan = new Lan (hub,page);
    lan.xywh.w = S1;
    lan.xywh.h = S1;
    right.childs.put (lan);

    auto wifi = new Wifi (hub,page);
    wifi.xywh.w = S1;
    wifi.xywh.h = S1;
    right.childs.put (wifi);

    auto volume = new Volume_ (hub,page);
    volume.xywh.w = S1;
    volume.xywh.h = S1;
    right.childs.put (volume);

    auto battery = new Battery (hub,page);
    battery.xywh.w = S1;
    battery.xywh.h = S1;
    right.childs.put (battery);

    //
    return cast (Widget*) main;
}

//
struct
Main {
    mixin _Widget;
}

struct
Left {
    mixin _Widget;
}

struct
Center {
    mixin _Widget;
}

struct
Right {
    mixin _Widget;
}

//
struct
Start {
    mixin _Widget!Button;
}

struct
Clock {
    mixin _Widget!Button;
}

struct
Lan {
    mixin _Widget!Button;
}

struct
Wifi {
    mixin _Widget!Button;
}

struct
Volume_ {
    mixin _Widget!Volume;

    void
    on_pressed () {
        with (o)
        hub.QUICK_SETTINGS ();
    }
}

struct
Battery {
    mixin _Widget!Button;
}
