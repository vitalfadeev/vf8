import std.stdio;

import hub 								: Hub;
import vf.gui.page                      : Page;
import vf.gui.color                     : Color;
import vf.std.xywh                      : Xy,Wh,Xywh;
import vf.gui.style 					: Style;
import mod.widget 						: Widget;
import std.string 						: startsWith;
version (SDL) import vf.sdl.input       : Input;
version (SDL) import vf.sdl.importc_sdl : SDL_Event,SDL_EventType, SDL_WindowEventID;
version (SDL) import vf.sdl.importc_sdl : SDL_GetWindowFromID, SDL_DestroyWindow;


static O o;

void 
main () {
	o = O ();
	with (o) {
		// Register
		import mod.sdl;
		import mod.sdl_wm;
		import mod.widget;
		import mod.volume;
		version (ACTIONS) import mod.action;

		hub.register (new Sdl);
		hub.register (new Sdl_wm);
		hub.register (new Mod_widget);
		hub.register (new Volume);
		version (ACTIONS) hub.register (new Actions);

		// INIT
		hub.INIT ();

		// Load page
		pages ~= new Page ();
		pages[$-1].wh.w = 1024;
		pages[$-1].wh.h = 600;
		pages[$-1]._init ();
		pages[$-1]._layout ();
		hub.register (pages[$-1]);

		// Layout
		hub.LAYOUT ();

		// Event loop
		foreach (evt; input) {
			hub.DO_SWITCH (evt);
			if (quit) break;
		}
	}
}


struct
O {
    Input!Event input;
    bool 		quit;
    Page*[]     pages;
    Hub         hub;
}

// SDL_Event sdl_event
// Event
//   union
//     SDL_Event
//     type > 0x8000
// cast (Event) sdl_event

struct
Event {
    SDL_Event sdl;
    alias sdl this;
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
