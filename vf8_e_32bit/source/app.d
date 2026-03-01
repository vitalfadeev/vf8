import std.stdio;

import vf.gui.page                      : Page;
import vf.gui.color                     : Color;
import vf.std.xywh                      : XY,WH,XYWH;
import vf.gui.style 					: Style;
import mod.widget 						: Widget;
version (SDL) import vf.sdl.input       : Input;
version (SDL) import vf.sdl.importc_sdl : SDL_Event,SDL_EventType, SDL_WindowEventID;
version (SDL) import vf.sdl.importc_sdl : SDL_GetWindowFromID, SDL_DestroyWindow;


void 
main () {
	auto o = O ();
	o.page = Page ();
	o.do_switch = &Mod().do_switch;

	// INIT
	with (o)
	with (Event.Type)
	send_now (INIT);

	// Event loop
	with (o)
	foreach (evt; input) {
		evt.o      = &o;
		evt.i      = 0;
		evt.widget = null;
		do_switch (evt);
		if (quit) break;
	}
}


struct
O {
    Input!Event input;
    bool 		quit;
    DO_SWITCH   do_switch;
    Page        page;  // base page
    Page[]      pages;

    alias DO_SWITCH = void delegate (Event* evt);

    // send
	import vf.base.send;
	mixin vf.base.send.Send!Event;
}

// SDL_Event sdl_event
// Event
//   union
//     SDL_Event
//     type > 0x8000
// cast (Event) sdl_event

template
Evtmix (RECS...) {
	enum Mod = RECS[0];
	enum Kls = RECS[1];
	enum Evt = RECS[2];
	enum Var = RECS[3];

	import std.format : format;

	static if (RECS.length == 0) 
		enum Evtmix = "";
	static if (RECS.length == 4) 
		enum Evtmix =  
			format!"import %s : %s;\n" (Mod,Kls) ~
			format!"%s._Event.%s %s;\n" (Kls,Evt,Var);
	static if (RECS.length > 4) 
		enum Evtmix =  
			format!"import %s : %s;\n" (Mod,Kls) ~
			format!"%s._Event.%s %s;\n" (Kls,Evt,Var) ~ 
			Evtmix!(RECS[4..$]);
	static if (RECS.length < 4) 
		static assert (0, "expect RECS.length >= 4");
}

alias EType = ushort;

struct
Event {
union {
    Type   type;
    Init   _init;
    mixin (Evtmix!(
    	"mod.sdl",    "Mod_sdl",    "SDL_Event", "sdl",
    	"mod.draw",   "Mod_draw",   "Draw",      "draw",
    	"mod.draw",   "Mod_draw",   "Redraw",    "redraw",
    	"mod.click",  "Mod_click",  "Click",     "click",
    	"mod.action", "Mod_action", "Action",    "action",
    	"mod.volume", "Mod_volume", "Volume",    "volume",
	));
}
	O*      o;
    ubyte   i;    // e index
    XYWH    xywh; // e xywh
    Widget* widget;    // e

    // Type
    import vf.std.mixin_enum : Enum;

    enum 
    _Type :EType {  // 0xFFFF
    	INIT,
    }

    mixin Enum!("Type", 0x8000, 
    	"app",               "Event._Type",
    	"mod.sdl",           "Mod_sdl._Event.Type",
    	"mod.draw",          "Mod_draw._Event.Type",
    	"mod.click",         "Mod_click._Event.Type",
    	"mod.action",        "Mod_action._Event.Type",
    	"mod.widget.button", "Button._Event.Type",
    	"mod.volume",        "Mod_volume._Event.Type",
    	//"mod.widget_volume", "Widget_volume._Event.Type",
    	//"mod.show_quick_settings", "Show_quick_settings._Event.Type",
		);

    struct
    Base {
        Type type = Type._;
    }

    struct
    Init {
        Type type = Type.INIT;
    }

    string
    type_to_string () {
    	import vf.sdl.importc_sdl : SDL_USEREVENT;
    	import std.conv : to;
    	if (this.type < SDL_USEREVENT)
    		return (cast (SDL_EventType) this.sdl.type).to!string;    	
    	else
    		return this.type.to!string;
    }
}

struct
Mod {
	void
	do_switch (Event* evt) {
		log_event (evt);

		version (SDL) import mod.sdl : Mod_sdl;
		version (SDL) 
		Mod_sdl     ().do_switch (evt);

	    switch (evt.type) with (Event.Type) {
	        case INIT   : _do_init   (evt); break;
	        default     :
	    }

	    import mod.draw : Mod_draw;
	    Mod_draw    ().do_switch (evt);
	    import mod.widget : Mod_widget;
	    Mod_widget  ().do_switch (evt);  // set evt.i
	    version (ACTIONS) import mod.action : Mod_action;
		version (ACTIONS) 
		Mod_action  ().do_switch (evt);
	}

	void
	_do_init (Event* evt) {
		with (evt._init) {
			init_window (evt);
			init_gui (evt);
		}
	}

	void
	init_window (Event* evt) {
		import vf.sdl.wm : Wm;
		Wm ().new_window ();
	}

	void
	init_gui (Event* evt) {
		_init_page (evt);
	}

	void
	_init_page (Event* evt) {
	    evt.o.page._init ();
	}
}


void
log_event (Event* evt) {
	import std.stdio : writefln;
	import vf.sdl.importc_sdl;

	with (Event.Type)
	if (evt.sdl.type == SDL_MOUSEMOTION)
	    {}
	else
	if (evt.sdl.type == SDL_MOUSEWHEEL)
		writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, cast (SDL_MouseWheelDirection) evt.sdl.wheel.direction);
	else
	if (evt.sdl.type == SDL_WINDOWEVENT)
	    writefln ("%s %d %s ", cast (SDL_EventType)evt.sdl.type, evt.sdl.window.windowID, cast (SDL_WindowEventID) evt.sdl.window.event);
	else
	if (evt.sdl.type == SDL_KEYDOWN)
	    writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, evt.sdl.key.keysym.scancode);
	else
	if (evt.sdl.type == SDL_KEYUP)
	    writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, evt.sdl.key.keysym.scancode);
	else
	if (evt.sdl.type < SDL_USEREVENT)
	    writefln ("%s", cast (SDL_EventType) evt.sdl.type);    
	else
	    writefln ("%s", cast (Event.Type) evt.type);
}

alias I  = ubyte;

// e start
// e b2 
// e b3
// 
// e 
// e
// e clock
// e 
// e  
// 
// e 
// e
// e indicators
//
// colors
//   base       fg/bg
//   selected   fg/bg
//   disabled   fg/bg
//   focused    fg/bg
//   hover      fg/bg
//   pressed    fg/bg
//   lamp       fg/bg
//
// base   fg/bg
// info   fg/bg
// warn   fg/bg
// error  fg/bg

// windows
// fonts
// icons
// sounds

// start
//
// clock
//
// clipboard
// locale
// indicators
//  lan
//  wifi
//  sound
//  batary
//
// start
//   w 128
//   button
//     on click ...
//
// clock
//   button
//     on click ...
//
// clipboard
//   button
// locale
//   button
// indicators
//   button
//     on click ...   // catch click on any of lan,wifi,sound,batary
//     on click SHOW_QUICK_SETTINGS
//
// grid 256x256
//
// layout
// 1:1 3:1 5:3
// 1:1 3:1 5:7

// page 2
// QUICK_SETTINGS
// 1   2 2 2
// 3 -------
// 3 -------
// 4--- ---4
// 4--- ---4
// 4--- ---4
//
// bat    setting lock quit
// volume
// bright
// lan                 wifi
// power              light
// style               avia
//
// bat
//   w 128
//
//


// 🛜 — Wireless (U+1F6DC
// 📶 — Antenna Bars (U+1F4F6):
// ᯤ — Tai Tham Consonant Sign Low 
// 
// █ (U+2588) — Сигнал 4/4
// ▆ (U+2587) — Сигнал 3/4
// ▄ (U+2584) — Сигнал 2/4
// ▂ (U+2582) — Сигнал 1/4
// _ (U+005F) — Нет сигнала 
//
// 
// 󰖩 󰖪
//  󰢼  󰢽  󰢾 
//  󰢼  󰢽  󰢾 󰢿
// 󰤟 
// 󱚵
// https://www.nerdfonts.com/cheat-sheet
// 󰤟 \udb82\udd1f 
// 󰤟 󰤢 󰤥 󰤨 󰤭 󰤯 󰤠 󰤡 󰤣 󰤤 󰤦 󰤧 󰤩 󰤪 󰤫 󰤬 󰤮 󱛋 󱛌 󱛍 󱛎 󱛏
// 
//        󰕾 󰕿 󰖀 󰝞 󰝟 󰖁 󰝝 󱄠 󱄡

// slider
//   on change APP_EVENT value  // value = 0..0xFF position
// button
//   on click APP_EVENT value   // value = 0..1    pressed
// checkbox
//   on click APP_EVENT value   // value = 0..1    checked
// radio
//   on click APP_EVENT value   // value = 0..0xFF id
// select
//   on click APP_EVENT value   // value = 0..0xFF id
// text
//   on change APP_EVENT value  // value = 0..0xFFFF wchar
//   on key APP_EVENT value     // value = 0..0xFF   scancode

// Sounds
//   PLAY? 1
//     send PLAY! 1
// E
//   PLAY! 1
//     lamp_on
//   CLICK
//     pressed
//     send PLAY? 1
//   PLAY_END! 1
//     lamp_off

// PLAY?
// PLAY!

// Sounds
//   PLAY_REQUEST
//     send PLAY_START
//     send PLAY_END
//     send PLAY_INFO
// E
//   PLAY_START
//     lamp_on
//   PLAY_END
//     lamp_off
//   CLICK
//     pressed
//     send PLAY_REQUEST

// Sounds
//   PLAY_REQUEST n
//     send PLAY_START n
//     send PLAY_END n
//     send PLAY_INFO n
// E
//   PLAY_START n
//     lamp_on
//   PLAY_END n
//     lamp_off
//   CLICK
//     pressed
//     send PLAY_REQUEST n
//     send CLICK_INFO e.id
//   CHANGE_REQUEST value
//     send CHANGE_INFO e.id

// PLAY
//   PLAY 0  // request
//   PLAY 1  // start
//   PLAY 2  // end
//   PLAY 3  // info

// Event
//   code
//   flag  // request.start.end.info
//
//  00000011
//        00 requesr
//        01 start
//        10 end
//        11 info
//
// SDL_USEREVENT
// 0x8000
// 1000_0000_0000_0000
// 1000_0000_0000_0011
// 1000_0000_0000_0100 PLAY request
// 1000_0000_0000_0101 PLAY start
// 1000_0000_0000_0110 PLAY end
// 1000_0000_0000_0111 PLAY info
//
// EVENT!("PLAY", ["REQUEST", "START", "END", "INFO"])

//enum
//Event2 {
//	PLAY = 0x8000 | (1 << 2),
//	PLAY_REQUEST = PLAY,
//	PLAY_START,
//	PLAY_END,
//	PLAY_INFO,
//	OPEN = 0x8000 | (2 << 2),
//	OPEN_REQUEST = OPEN,
//	OPEN_START,
//	OPEN_END,
//	OPEN_INFO
//}

// Button
//       pressed released
// icon  .       .
//
// Check
//       pressed released
// icon  .       .
//
// Volume
//       mute low mid high 
// icon  .    .   .   .

//  +-----------+
// SDL     PRESSED
//  |    RELEASEED
//  |           |
//  +-----------+
//
// SDL
//   PRESSED
// SDL
//   RELEASED
// 
// Event
//  |
// 1 2 3 4 5 6 7.. 255
//
//
