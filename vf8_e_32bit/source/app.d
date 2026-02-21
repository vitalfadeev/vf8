import std.stdio;

import vf.gui.page                      : Page;
import vf.gui.colors                    : Color, Colors;
import vf.gui.e                         : E;
import vf.std.xywh                      : XY,WH,XYWH;
import vf.gui.style 					: Style;
version (SDL) import vf.sdl.input       : Input;
version (SDL) import vf.sdl.importc_sdl : SDL_Event,SDL_EventType, SDL_WindowEventID;
version (SDL) import vf.sdl.fonts       : Fonts;
version (ACTIONS) import vf.base.actions : Actions;


void 
main () {
	auto o = O ();
	o.page = Page ();
	o.page.es.length = 12;
	Mod mod;
	o.do_switch = &mod.do_switch;

	with (o.page.layout.grid) {
		import vf.sdl.window : WINDOW_DEFAULT_W, WINDOW_DEFAULT_H;
		total_wh.w     = WINDOW_DEFAULT_W;
		total_wh.h     = 64;
		cells_offset_x =  0;
		cells_space_x  =  0;
		cells_w        = 64;
		cells_h        = 64;
		first_cell_w   = 64;
		first_cell_h   = 64;
		order[0] = Order_rec (1,3);
		order[1] = Order_rec (2,2);
		order[2] = Order_rec (3,1);
		order[3] = Order_rec (4,2);
		order[4] = Order_rec (5,3);
	}
	foreach (xywh; o.page.layout.range) {
		import std.stdio : writeln;
		writeln (xywh);
	}

	// INIT
	with (o)
	with (Event.Type)
	send_now (INIT);

	// Event loop
	with (o)
	foreach (evt; input) {
		evt.o = &o;
		do_switch (evt);
		if (quit) break;
	}
}


struct
O {
    Input!Event input;
    Windows     wm;
    Page        page;
    //
    Colors      colors;
	Fonts 		fonts;
	Styles 		styles;
    bool 		quit;
    DO_SWITCH   do_switch;

    alias DO_SWITCH = void delegate (Event* evt);

	import vf.base.send;
	mixin vf.base.send.Send!Event;
	
	version (SDL) import vf.sdl.send;
	version (SDL) mixin vf.sdl.send.Send!Event;

	version (ACTIONS) import vf.base.actions;
	version (ACTIONS) mixin vf.base.actions.Send!Event;
}

// SDL_Event sdl_event
// Event
//   union
//     SDL_Event
//     type > 0x8000
// cast (Event) sdl_event

struct
Event {
union {
    Type   type;
    version (SDL) SDL_Event sdl;
    Init   init_;
    Draw   draw;
    Redraw redraw;
    Click  click;
    Action action;
}
	O*     o;
    ubyte  i;    // e index
    XYWH   xywh; // e xywh

    enum
    Type {  // 0xFFFF
    	_ = 0x8000,
    	INIT,
    	DRAW,
    	REDRAW,
    	CLICK,
    	//
    	ACTION,
    	//
    	SHOW_QUICK_SETTINGS,
    }

    struct
    Base {
        Type type = Type._;
    }

    struct
    Init {
        Type type = Type.INIT;
    }

    struct
    Draw {
        Type type = Type.DRAW;
        version (SDL) import vf.sdl.renderer_sdl : Renderer;
        version (SDL) import vf.sdl.window       : Window;
        version (SDL) Window*   window;
        version (SDL) Renderer* renderer;
        XYWH xywh;
    }

    struct
    Redraw {
        Type type = Type.REDRAW;
        XYWH xywh;
    }

    struct
    Click {
    	Type type = Type.CLICK;
        XY   xy;
    }

    struct
    Action {
    	Type   type = Type.ACTION;
        string name;
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

		version (SDL)
		switch (evt.sdl.type) with (SDL_EventType) {
		    case SDL_QUIT            : _do_sdl_quit   (evt); break;
		    case SDL_WINDOWEVENT     : _do_sdl_window (evt); break;
		    case SDL_KEYDOWN         : _do_sdl_keydown (evt); break;
		    default                  :
		}

	    switch (evt.type) with (Event.Type) {
	        case INIT   : _do_init   (evt); break;
	        case DRAW   : _do_draw   (evt); break;
	        case REDRAW : _do_redraw (evt); break;
	        default     :
	    }

	    Mod_type_button ().do_switch (evt);  // set evt.i
	    Mod_type_on     ().do_switch (evt);
		version (ACTIONS) Actions!Event   ().do_switch (evt);
	}

	void
	_do_init (Event* evt) {
		with (evt.init_) {
			version (SDL) init_sdl (evt);
			init_window (evt);
			init_gui (evt);
		}
	}

	version (SDL)
	void
	init_sdl (Event* evt) {
		import vf.sdl.init_sdl : init_sdl;
		init_sdl ();
	}

	void
	init_window (Event* evt) {
		evt.o.wm.new_window;
	}

	void
	init_gui (Event* evt) {
		_init_colors (evt);
		_init_fonts  (evt);
		_init_images (evt);
		_init_es     (evt);
		_init_styles (evt);
	}

	void
	_init_colors (Event* evt) {
		evt.o.colors.s[0] = 0xFF000000;  // dark
		evt.o.colors.s[1] = 0xFF444444;  // base
		evt.o.colors.s[2] = 0xFF888888;  // base-1
		evt.o.colors.s[3] = 0xFFCCCCCC;  // base-2
		evt.o.colors.s[4] = 0xFF883333;  
		evt.o.colors.s[5] = 0xFFFFFFFF;  
	}

	void
	_init_fonts (Event* evt) {
		evt.o.fonts._init ();
	}

	void
	_init_images (Event* evt) {
	    //
	}

	void
	_init_es (Event* evt) {
	    evt.o.page.es[0].type  = 1; // start 
	    evt.o.page.es[1].type  = 0;
	    evt.o.page.es[2].type  = 0;
	    evt.o.page.es[3].type  = 0;
	    evt.o.page.es[4].type  = 0;
	    evt.o.page.es[5].type  = 2; // clock
	    evt.o.page.es[6].type  = 0;
	    evt.o.page.es[7].type  = 0;
	    evt.o.page.es[8].type  = 3; // indicators
	    evt.o.page.es[9].type  = 4; // indicators
	    evt.o.page.es[10].type = 5; // indicators
	}

	void
	_init_styles (Event* evt) {
		evt.o.styles._init (evt);
	}

	void
	_do_draw (Event* evt) {
		with (evt.o)
		with (evt.draw) {
			import std.range     : lockstep;
			import vf.gui.colors : Color;

			renderer.fonts = &fonts;

		    foreach (e,xywh; lockstep (page.es.range, page.layout.range)) {
		    	auto style = styles.get_e_style (*e);

			    with (xywh)
				with (style)
			    if (w > 0 && h > 0)
			    	renderer.draw_rect (x,y,w,h,colors.s[fg],colors.s[bg]);

				with (xywh)
				with (style)
				if (text.length)
					renderer.draw_text (font,x,y,w,h,colors.s[fg],colors.s[bg],text);
		    }
		}
	}

	version (SDL) 
	void
	_do_redraw (Event* evt) {
		with (evt.o)
		with (evt.redraw) {
			auto _window = wm.window.window;
    		import vf.sdl.renderer_sdl : Renderer;
			Renderer renderer;
    		renderer.draw_start (_window);
    		with (Event.Type)
    		send_now (DRAW,&renderer);
    		renderer.draw_end (_window);
		}
	}

	//void
	//_do_click (Event* evt) {
	//	import std.algorithm : filter;
	//	with (evt.click) {
	//		ubyte i;
	//		foreach (xywh; o.page.layout.select (xy)) {
	//			if (xywh.has (xy)) {
	//				o.page.es[i].pressed = !o.page.es[i].pressed;
	//				on (i, evt);
	//				with (Event.Type)
	//				send (REDRAW,xywh);
	//			}
	//			i++;
	//		}
	//	}
	//}	

	version (SDL)
	void
	_do_sdl_quit (Event* evt) {
		with (evt.sdl.quit) {
			evt.o.quit = true;
		}
	}	

	version (SDL)
	void
	_do_sdl_window (Event* evt) {
		with (evt.o)
		with (evt.sdl.window)
    	switch (event) with (SDL_WindowEventID) {
    		case SDL_WINDOWEVENT_CLOSE:
    			break;
    		case SDL_WINDOWEVENT_EXPOSED:
	    		import vf.sdl.renderer_sdl : Renderer;
    			Renderer renderer;
	    		renderer.draw_start (&evt.sdl);
	    		with (Event.Type)
	    		send_now (DRAW, &renderer);
	    		renderer.draw_end (&evt.sdl);
	    		break;
		    default:
		}
	}

	version (SDL)
	void
	_do_sdl_keydown (Event* evt) {
		import vf.sdl.importc_sdl;
		// SDL_KEYDOWN
		// SDL_KEYUP
		with (evt.o)
		with (evt.sdl.key)
    	switch (keysym.scancode) {
		    case SDL_SCANCODE_ESCAPE : quit = true; break;
		    case SDL_SCANCODE_Q      : quit = true; break;
		    default                  :
		}
	}
}

version (SDL)
struct
Mod_type_button {
    void
    do_switch (Event* evt) {
    	switch (evt.sdl.type) with (SDL_EventType) {
    	    case SDL_MOUSEBUTTONDOWN : _do_sdl_button (evt); break;
    	    default                  :
    	}
    }

    void
    _do_sdl_button (Event* evt) {
    	version (SDL)
    	{
    		import vf.sdl.importc_sdl;

			with (evt.o)
			with (Event.Type)
			with (evt.sdl.button) {
				auto xy = XY (x,y);
				foreach (i,xywh; page.layout.select (xy)) {
			    	switch (button) {
					    case SDL_BUTTON_LEFT   : page.es[i].pressed  = !page.es[i].pressed;  break;
						case SDL_BUTTON_MIDDLE : page.es[i].disabled = !page.es[i].disabled; break;
						case SDL_BUTTON_RIGHT  : page.es[i].selected = !page.es[i].selected; break;
		    			default                :
					}
					evt.i    = i;
					evt.xywh = xywh;
					send (REDRAW,xywh);

					version (ACTIONS) send (evt.o,"e.action");
				}
			}
    	}
    	else
    	{
    		import vf.sdl.importc_sdl : SDL_BUTTON_LEFT, SDL_BUTTON_RIGHT;
    		// SDL_MOUSEBUTTONDOWN
    		// SDL_MOUSEBUTTONUP
    		with (evt.sdl.button)
        	switch (button) {
    		    case SDL_BUTTON_LEFT  : 
    		    	Event event2;
    		    	event2.type = Event.Type.CLICK;
    		    	event2.click.xy.x = x;
    		    	event2.click.xy.y = y;
    		    	send_now (&event2);
    		    	break;
    		    case SDL_BUTTON_RIGHT : break;
    		    default               :
    		}
    	}
    }
}

version (SDL)
struct
Mod_type_on {
    void
    do_switch (Event* evt) {
	    with (evt.o)
	    with (EType)
	    if (page.es[evt.i].type == BUTTON)
    	switch (evt.sdl.type) with (SDL_EventType) {
    	    case SDL_MOUSEBUTTONDOWN : _do_sdl_button (evt); break;
    	    default                  :
    	}
    }

    void
    _do_sdl_button (Event* evt) {
		_do_on (evt);
    }

	void
	_do_on (Event* evt) {
		with (evt.o)
		if (evt.i >= 0)
		if (evt.i < page.es.length)
		switch (page.es[evt.i].type) {
			case 1  : break;  // type 1
			case 2  : break;
			case 3  : break;
			case 4  : /*send ("Quit");*/ break;
			case 5  : /*send (SHOW_QUICK_SETTINGS);*/ break;
			default :
		}

		//
		with (evt.o)
    	if (evt.i >= 0 && evt.i < page.es.length) {
	    	import std.stdio : writefln;
	    	writefln ("on %d %s", evt.i, cast (SDL_EventType) evt.type);
	    	writefln ("   %s", page.es[evt.i]);
    	}
	}

	enum
	EType {
		_,
		BUTTON,
	}
}

struct
Windows {
	import vf.sdl.window : Window;

	Window window;

    void
    new_window () {
    	window.window = window.new_window ();
    }
}


struct
Styles {
	Style[2^^6][256] styles;  // 256 types * 6 flags
	pragma (msg, "styles.size: ", styles.sizeof);  // 786_432

	Style*
	get_e_style (E e) {
		ubyte flags = 
			(e.disabled ? 0x01 : 0) |
			(e.pressed  ? 0x02 : 0) |
			(e.selected ? 0x04 : 0) |
			(e.focused  ? 0x08 : 0) |
			(e.m_over   ? 0x10 : 0) |
			(e.lamp_on  ? 0x20 : 0);
		return &styles[e.type][flags];
	}

	void
	_init (Event* evt) {
		foreach (t,ref ss; styles) {
		    foreach (i,ref s; ss) {
		        switch (i) {
		            case 0x00 /* base     */: s.fg = 3; s.bg = 1; break;
		            case 0x02 /* pressed  */: s.fg = 5; s.bg = 3; break;
		            case 0x04 /* selected */: s.fg = 3; s.bg = 4; break;
		            case 0x08 /* focused  */: s.fg = 3; s.bg = 2; break;
		            default:
		        }
				switch (t) {
					case 1 /* start  */ : s.font = 1; s.text = ""; break;
					case 2 /* clock  */ : s.font = 2; s.text = ""; break;
					case 3 /* batary */ : s.font = 1; s.text = "󰁹"; break;
					case 4 /* volume */ : s.font = 1; s.text = ""; break;
					case 5 /* avia   */ : s.font = 1; s.text = "󰀝"; break;
				    default:
				}
		    }
		}

	    // disabled pressed selected focused m_over lamp_on
	    // 16
	    // type * 16  // base, button, check, radio, select, text
	    // 6*16 = 96 styles * 10 = 960 Bytes
	    //
	    // max
	    // 256 types * 6 flags = 1536 * 10 = 15_360 Bytes
	    // 256 types * 2^6 flags = 256*64 = 16384 *10 = 163_840 Bytes
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
	if (evt.sdl.type == SDL_WINDOWEVENT)
	    writefln ("%s %s", cast (SDL_EventType)evt.sdl.type, cast (SDL_WindowEventID) evt.sdl.window.event);
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
// images
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

