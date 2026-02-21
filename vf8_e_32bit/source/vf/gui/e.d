module vf.gui.e;

version (GUI):
version (E_32BIT_PAGED):


// page
//  e
//  e
struct 
E {
    //ubyte flags1;         // 3  // 32 bit       //
    //ubyte flags2;         //    //              //
    //ubyte flags3;         //    //              //
    //ubyte id;             // 1  //              //

    bool disabled:1;  // enabled  / disabled
    bool unvisible:1; // visible  / unvisible
    bool focused:1;   // focused  / 
    bool selected:1;  // selected / 
    bool m_over:1;    // m_over   /
    bool defined:1;   // defined  / undefined
    bool pressed:1;   // pressed  / released
    bool lamp_on:1;   // lamp_on  / lamp_off
    // 8
    ubyte type;  // button, checkbox, text, textarea, select
                 //   wh, fg, bg, font, text, image, on
    // 16
    ubyte reserved1; 
    // 24
    ubyte reserved2; 
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

