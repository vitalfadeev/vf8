import std.stdio;

import vf.gui.page                      : Page;
import vf.gui.colors                    : Color;
import vf.gui.e                         : E;
import vf.std.xywh                      : XY,WH,XYWH;
version (SDL) import vf.sdl.input       : Input;
version (SDL) import vf.sdl.importc_sdl : SDL_Event,SDL_EventType, SDL_WindowEventID;
version (SDL) import vf.sdl.fonts       : Fonts;


void 
main () {
	auto o = O ();
	o.page = Page ();
	o.page.es.length = 12;
	static Mod!O mod;
	mod.o = &o;

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
	with (Event.Type)
	mod.send_now (INIT);

	// Event loop
	foreach (evt; o.input) {
		evt.o = &o;
		mod.do_switch (evt);
		if (mod.quit) break;
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
}

struct
Mod (I) {
	O* o;
	bool quit;

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

	    enum
	    EType {
	    	_,
	    	BUTTON,
	    }
	    // is GUI xy
	    // select E
	    // set evt i
	    static Mod_type_button!O mod_type_button;
	    mod_type_button.o = o;
	    mod_type_button.do_switch (evt);  // set evt.i
	    with (EType)
	    if (o.page.es[evt.i].type == BUTTON) {
		    static Mod_type_on!O mod_type_on;
		    mod_type_on.o = o;
		    mod_type_on.do_switch (evt);
	    }

	    // Cusom type
	    // ...

	    // app
		static Mod_app!O mod_app;
		mod_app.o = o;
		mod_app.do_switch (evt);  // set evt.i

		// actions
		import vf.base.actions : Actions;
		static Actions!(O,Event) actions;
		actions.o = o;
		actions.do_switch (evt);
	}

	void
	_do_init (Event* evt) {
		with (evt.init_) {
			version (SDL) import vf.sdl.init_sdl : init_sdl;
			version (SDL) init_sdl ();
			init_window ();
			init_gui ();
		}
	}

	void
	init_window () {
		o.wm.new_window;	    
	}

	void
	init_gui () {
		_init_colors ();
		_init_fonts ();
		_init_images ();
		_init_es ();
	}

	void
	_init_colors () {
		Color[8] c;
		c[0] = 0xFF000000;
		c[1] = 0xFF444444;
		c[2] = 0xFF888888;
		c[3] = 0xFFCCCCCC;
		c[4] = 0xFF883333;
		//       aaBBGGRR

		o.colors.base.fg     = c[3];
		o.colors.base.bg     = c[1];
		o.colors.disabled.fg = c[1];
		o.colors.disabled.bg = c[0];
		o.colors.pressed.fg  = c[3];
		o.colors.pressed.bg  = c[2];
		o.colors.selected.fg = c[3];
		o.colors.selected.bg = c[4];
	}

	void
	_init_fonts () {
		o.fonts._init ();
	}

	void
	_init_images () {
	    //
	}

	void
	_init_es () {
	    o.page.es[0].type  = 1; // start 
	    o.page.es[1].type  = 0;
	    o.page.es[2].type  = 0;
	    o.page.es[3].type  = 0;
	    o.page.es[4].type  = 0;
	    o.page.es[5].type  = 2; // clock
	    o.page.es[6].type  = 0;
	    o.page.es[7].type  = 0;
	    o.page.es[8].type  = 3; // indicators
	    o.page.es[9].type  = 4; // indicators
	    o.page.es[10].type = 5; // indicators
	}

	void
	_do_draw (Event* evt) {
		with (evt.draw) {
			import std.range     : lockstep;
			import vf.gui.colors : Color;

			renderer.fonts = &o.fonts;

		    foreach (e,xywh; lockstep (o.page.es.range, o.page.layout.range)) {
		    	auto fgbg = get_color (o,*e);

			    with (xywh)
			    if (w > 0 && h > 0)
			    	renderer.draw_rect (x,y,w,h,fgbg.fg,fgbg.bg);

			    auto   fg = fgbg.fg;
			    auto   bg = fgbg.bg;
			    uint   font;
			    string text;
			    get_e_style (*e,&fg,&bg,&font,&text);
				with (xywh)
				with (evt.draw) 
				if (text.length)
					renderer.draw_text (font,x,y,w,h,fg,bg,text);
		    }
		}
	}

	void
	get_e_style (E e, Color* fg, Color* bg, uint* font, string* text) {
		switch (e.type) {
			case 1  : *font = 0; *text = ""; break;
			case 2  : *font = 1; *text = ""; break;
			case 3  : *font = 0; *text = "󰁹"; break;
			case 4  : *font = 0; *text = ""; break;
			case 5  : *font = 0; *text = "󰀝"; break;
			default :
		}
	}

	version (SDL) 
	void
	_do_redraw (Event* evt) {
		with (evt.redraw) {
			auto _window = o.wm.window.window;
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
			quit = true;
		}
	}	

	version (SDL)
	void
	_do_sdl_window (Event* evt) {
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
		with (evt.sdl.key)
    	switch (keysym.scancode) {
		    case SDL_SCANCODE_ESCAPE : quit = true; break;
		    case SDL_SCANCODE_Q      : quit = true; break;
		    default                  :
		}
	}

	import vf.base.send;
	mixin vf.base.send.Send!Event;
	version (SDL) import vf.sdl.send;
	version (SDL) mixin vf.sdl.send.Send!Event;
}

version (SDL)
struct
Mod_type_button (O) {
	O* o;

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

			with (Event.Type)
			with (evt.sdl.button) {
				auto xy = XY (x,y);
				foreach (i,xywh; o.page.layout.select (xy)) {
			    	switch (button) {
					    case SDL_BUTTON_LEFT   : o.page.es[i].pressed  = !o.page.es[i].pressed;  break;
						case SDL_BUTTON_MIDDLE : o.page.es[i].disabled = !o.page.es[i].disabled; break;
						case SDL_BUTTON_RIGHT  : o.page.es[i].selected = !o.page.es[i].selected; break;
		    			default                :
					}
					evt.i    = i;
					evt.xywh = xywh;
					send (REDRAW,xywh);

					import vf.base.actions : send;
					send!(o,Event) ("QUIT");
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

	import vf.base.send;
	mixin vf.base.send.Send!Event;
	version (SDL) import vf.sdl.send;
	version (SDL) mixin vf.sdl.send.Send!Event;
}

version (SDL)
struct
Mod_type_on (O) {
	O* o;

    void
    do_switch (Event* evt) {
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
		if (evt.i >= 0)
		if (evt.i < o.page.es.length)
		switch (o.page.es[evt.i].type) {
			case 1  : break;  // type 1
			case 2  : break;
			case 3  : break;
			case 4  : break;
			case 5  : /*send (SHOW_QUICK_SETTINGS);*/ break;
			default :
		}

		//
    	if (evt.i >= 0 && evt.i < o.page.es.length) {
	    	import std.stdio : writefln;
	    	writefln ("on %d %s", evt.i, cast (SDL_EventType) evt.type);
	    	writefln ("   %s", o.page.es[evt.i]);
    	}
	}
}

struct
Mod_app (O) {
	O* o;

    void
    do_switch (Event* evt) {
    	switch (evt.type) with (Event.Type) {
    	    case SHOW_QUICK_SETTINGS : /*app_SHOW_QUICK_SETTINGS*/ break;
    	    default                  :
    	}
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

auto
get_color (O* o, E e) {
	if (e.disabled) { return o.colors.disabled; }
	if (e.pressed)  { return o.colors.pressed; }
	if (e.selected) { return o.colors.selected; }

	return o.colors.base;
}

struct
Colors {
    Fgbg disabled;
    Fgbg pressed;
    Fgbg selected;
    Fgbg base;

    struct
    Fgbg {
        Color fg;
        Color bg;
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
//   on click ...
//   w 128
//   button
//
// clock
//   on click ...
//   button
//
// clipboard
//   button
// locale
//   button
// indicators
//   on click ...   // catch click on any of lan,wifi,sound,batary
//   button
//
// grid 256x256
//
// layout
// 1:1 3:1 5:3
// 1:1 3:1 5:7

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
