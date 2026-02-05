import core.stdc.stdio : printf;
import std.stdio       : writeln;
import vf.types        : GO,REG;
import vf.o            : O;
import vf.e_class      : E;
import vf.event        : Event;
import vf.attrs        : Calculated;
import vf.klass        : Klass;
import load_ui         : load_ui;
import importc;


extern(C)
void 
main () {
    auto o = new O ();
    o.open ();
    o.gui.e = load_ui (o);
    o.go ();   // event loop
}


//auto
//collect_hotkeys (E e) {
//    HKE[] hotkeys;

//    foreach (_e; e.childs_recursive) {
//        auto hk = _e.hotkey;
//        if (hk.type == hk.Type._hotkey) {            
//            if (hk._hotkey.a) {
//                hotkeys ~= HKE (_e,hk._hotkey.a);
//            }
//        }
//    }

//    return hotkeys;
//}

//struct
//HKE {
//    E      e;
//    string hk;
//}



// area
//  area
//   area
//   area
//   area
//  area
//   area
//  area
//   area
//   area
//   area

// e panel window canvas
//  e loc1
//   e button 1
//   e button 2
//   e button 3
//  e loc2
//   e button clock
//  e loc3
//   e indicator 1
//   e indicator 2
//   e indicator 3
//
// window
//   x = 0
//   y = top
//   w = screen.w
//   h = 64
//
// loc1
//   x = left
//   y = 0
//   w = 30%
//   h = parent.h
//
// loc2
//   x = center
//   y = 0
//   w = 30%
//   h = parent.h
//
// loc3
//   x = right
//   y = 0
//   w = 30%
//   h = parent.h
//
// button1
//  x = left
//  y = 0
//  w = parent.h
//  h = parent.h
//  icon = start
//
// button2
//  x = left
//  y = 0
//  w = parent.h
//  h = parent.h
//
// button3
//  x = left
//  y = 0
//  w = parent.h
//  h = parent.h

//
// on e
// on klass
// on indent
// on e-end

// on char

// key Q -> Play 1
//          btn 1 state pressed
// btn 1 -> btn 1 state pressed
//          Play 1
//
// hotkey
// colect_hotkeys
//   bind HOTKEY, PLAY 1
//   bind CLICK,  PLAY 1

// data.state  pressed | released
//   on data_changed
//      update_binded_widget
//
// e.binded_data
//
// on key press
//   data.state = pressed
//   data.update_binded_widget
// on key release
//   data.state = released
//   data.update_binded_widget
//
// on data
//   if data.state = pressed
//     widget.klasses add pressed
//   if data.state = released
//     widget.klasses rem pressed
//
// on data.state
//   pressed
//     widget.klasses add pressed
//   released
//     widget.klasses rem pressed
//
// data.value 
//   classes
//
// cond
//   classes
//
// o.dg_returned_1
//   add klass
//   else
//   rem klass
// e.on (&o.dg_returned_1, add klass, rem klass)

//
// on button press
//   dg
//     data = x
//     //send DATA_CHANGED
//     //send REDRAW
//
// data = x
//   send DATA_CHANGED
//   send REDRAW
//
// e 
//   DATA_CHANGED
//     data == x ? red : green
//   dynamic_klasses (&dg_data_eq_x, "red", "green")
//   dynamic_klasses (&data.flag_1, "red", "green")
//

// struct
// Data 
//   _x
//   void x (int a) { update_flags; send (DATA_CHANGED); send (REDRAW); }
//   int  x (     ) {}
//   
//   bool flag_1
//   void update_flags () { flag_1 = true; }

// e flag_1!red
// e flag_1_red
// flag_1_red = Flag_klass (&data.flag_1, red)

// e     button pressed red
// flags      1       2   3
// allow_klass red     flag_1
// deny_klass  pressed flag_2


// data
//   flag_1
//   on flag_1 == 1
//     send PLAY_START_1  // and ignore PLAY_START_1  // source data
//   on flag_1 == 0
//     send PLAY_STOP_1
//   on PLAY_START_1      // ignored on flag_1 == 1
//     flag_1 = 1
//     // no emit PLAY_START_1  // PLAY_START_1 == PLAY_START_1
//   on PLAY_STOP_1
//     flag_1 = 0
// widget
//   on PLAY_START_1
//     klass "plaing"
//   on PLAY_STOP_1
//     rem klass "plaing"
//   on CLICK
//     send PLAY_START_1
// key
//   on PRESS
//     send PLAY_START_1
//   on RELEASE
//     send PLAY_STOP_1
// audio
//   on PLAY_START_1
//     play 1.wav
//   on PLAY_STOP_1
//     stop 1.wav

// PLAY_START_1
//   connect data
//   connect widget
//   connect audio
// PLAY_STOP_1
//   connect data
//   connect widget
//   connect audio

// button
//   on PRESS event PLAY_START_1
//   on PLAY_START_1 event LAMP_ON
//   on LAMP_ON add_klass "lamp_on"

// key
//   SDLK_a - is connect name
//   SDLK_a - is out name
//   SDLK_a - is wire name
//
// widget
//   _SDLK_a - is in
//    PRESS  - is out

// key
//  SDLK_a
//    PLAY_1
// audio
//  _PLAY_1
//     play 1.wav
// mouse
//   BTN_DOWN x,y
// button
//  _BTN_DOWN
//    PLAY_1
//  _PLAY_1
//    PRESS
//  _PRESS
//    add_klass press
//
// widget
//  _PLAY_1
//     add klass "play"
//  _BTN_DOWN
//     PLAY_1

mixin template
Switches () {
    //void
    //_key_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case KEYDOWN: if (KEY_A == evt.key.keysym.scancode) send (PLAY_1); break;
    //        default:
    //    }
    //}

    //void
    //_audio_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case PLAY_1: play ("1.wav"); break;
    //        default:
    //    }
    //}

    //void
    //_mouse_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case BUTTON_LEFT: break;
    //        default:
    //    }
    //}

    //void
    //_button_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case BUTTON_LEFT : send (PLAY_1); break;
    //        case PLAY_1      : send (PRESS);  break;
    //        case PRESS       : add_klass ("press"); break;
    //        default:
    //    }
    //}

    //void
    //_widget_sw (Event* evt) {
    //    switch (evt.type) with (evt.type) {
    //        case PLAY_1      : add_klass ("play"); break;
    //        case BUTTON_LEFT : send (PLAY_1);      break;
    //        default:
    //    }
    //}
}


// e
//   on CLICK OPEN_LAUNCHER
//
// OPEN_LAUNCHER
//   exec "launcher"
//   show window "launcher"

// e window
//  e page
//    e icon data
//      e image
//      e text
//    e icon data
//    e icon data
//    e icon data
//    e icon data
//    e icon data
//    e icon data
//    e icon data
//    e icon data
//    e icon data
//
// data : Klass
//   set (k,evt,e,data)
//     e.childs[0].img  = data.img
//     e.childs[1].text = data.text
// 
