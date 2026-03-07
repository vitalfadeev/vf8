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
    dchar[] text;
    dchar[] text_set;
    string image;
    string image_set;
    ubyte event_on;
    ubyte event_on_arg;

    Get  get;

    struct
    Get {
        Color     fg;
        Color     bg;
        dchar[]   text;
        dchar[]   text_set;
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
