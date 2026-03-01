module vf.gui.style;

import vf.std.xywh   : WH;
import vf.gui.color  : Color;
import mod.widget    : Widget;


struct
Style {
    // for
    Widget.Type  type;
    Widget.Flags flags;
    
    // rules
    WH    wh;
    ubyte fg;
    ubyte bg;
    ubyte font;
    ubyte text;
    ubyte iconset;
    ubyte icon;
    ubyte event_on;
    ubyte event_on_arg;
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
