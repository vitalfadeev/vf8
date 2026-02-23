module vf.gui.style;

import vf.std.xywh   : WH;
import vf.gui.colors : Color;


struct
Style {
    // for
    ubyte type;
    union {
        ubyte flags;
    struct {
        bool disabled:1;  // enabled  / disabled
        bool unvisible:1; // visible  / unvisible
        bool focused:1;   // focused  / 
        bool selected:1;  // selected / 
        bool m_over:1;    // m_over   /
        bool defined:1;   // defined  / undefined
        bool pressed:1;   // pressed  / released
        bool lamp_on:1;   // lamp_on  / lamp_off
    }
    }
    
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
