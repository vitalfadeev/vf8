module vf.gui.style;

import vf.std.xywh   : WH;
import vf.gui.colors : Color;


struct
Style {
    WH    wh;
    ubyte fg = 1;
    ubyte bg;
    ubyte font = 1;
    ubyte text;
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
