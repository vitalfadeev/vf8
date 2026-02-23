module vf.gui.e;

version (GUI):
version (E_32BIT_PAGED):


// page
//  e
//  e
struct 
E {
    ubyte type;  // button, checkbox, text, textarea, select
                 //   wh, fg, bg, font, text, image, on
    // 8
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
    // 16
    ubyte flags2;  // iconset icon index, text char index
    // 24
    ubyte value;
    // 32

    // flags
    // widget
    //   type  // for button_pressed callback
    // style
    //   wh
    //   fg
    //   bg
    //   font
    //   text
    //   image
    //   event_on;  // on click event, on slide event
}
