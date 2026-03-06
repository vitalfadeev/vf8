module vf.gui.style;

import vf.std.xywh   : Wh;
import vf.gui.color  : Color;
import mod.widget    : Widget;
import vf.sdl.importc_sdl_ttf;

struct
Style {
    // for
    string       name;
    Widget.Flags flags;
    
    // rules
    Wh    wh;
    ubyte fg;
    ubyte bg;
    ubyte font;
    ubyte text;
    ubyte iconset;
    ubyte icon;
    ubyte event_on;
    ubyte event_on_arg;

    Get  get;

    struct
    Get {
        Color     fg;
        Color     bg;
        string    text;
        TTF_Font* font;
    }
}

// e
//   flags
//   widget
//     type  // for button_pressed callback
//   style
//     wh
//     fg
//     bg
//     font
//     text
//     image
//     event_on;  // on click event, on slide event
