module vf.gui.widget;

version (SDL):
import std.traits;
import std.string;
import std.traits;
import std.conv;
import std.algorithm;
import vf.std.xywh;
import vf.std.vars         : Vars,Vars2;
import vf.std.traits       : Functions_recursive;
import vf.gui.color        : Color;
import vf.gui.page         : Page;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl : Renderer;
import std.stdio           : writeln;
import app                 : o;
import hub                 : Hub;


class
Widget {
    Xywh     xywh;
    Flags    flags;
    Page     page;
    string   name;  // for debug
    // style
    Color    fg;
    Color    bg;
    dchar[]  text;
    dchar[]  text_set;
    Image    image;
    Image    image_set;
    // childs
    Childs   childs;

    this (Page page) {
        this.page = page;
        this.name = this.classinfo.name;
    }        

    struct
    Image {
        size_t length;
        void*  ptr;
    }

    void
    sdl_event_mouse_button_down (SDL_MouseButtonEvent* evt) {
        //
    }

    void
    sdl_event_mouse_button_up (SDL_MouseButtonEvent* evt) {
        //
    }

    void
    sdl_event_mouse_wheel (SDL_MouseWheelEvent* evt) {
        //
    }    

    void
    style () {
        //
    }    

    void 
    draw (Renderer* renderer) {
        style ();

        writeln ("default draw on widget");
    }

    void
    redraw () {
        page.redraw (/*cast(Widget)*/this);         
    }

    auto
    recursive () {
        return Recursive (this);
    }

    import std.range;   
    struct
    Recursive {  // in deep
        Widget front;
        Widget[][] childs_ranges;
        Widget _next;
        bool   empty () { 
            return (front is null);
        }
        void   popFront () { front = next (); }
        auto   next () {
            in_deep:
            if (!front.childs.empty) {
                childs_ranges ~= front.childs.s;
                return childs_ranges.back.front;
            }

            go_right:
            if (!childs_ranges.empty) {
                if (!childs_ranges.back.empty) {
                    childs_ranges.back.popFront ();
                    if (!childs_ranges.back.empty) {
                        return childs_ranges.back.front;
                    }
                    else {
                        goto go_up;
                    }
                }
                else {
                    goto go_up;
                }
            }

            go_up:
            if (!childs_ranges.empty) {
                childs_ranges.popBack ();
                goto go_right;
            }

            end:
            return null;
        }
    }

    auto 
    struct 
    Flags {
        ubyte a;

        bool enabled () { return (a & Mask.ENABLED)? true: false; }
        void enabled (bool b) { if (b) a |= Mask.ENABLED; else a &= !Mask.ENABLED; }
        bool pressed () { return (a & Mask.PRESSED)? true: false; }
        void pressed (bool b) { if (b) a |= Mask.PRESSED; else a &= ~Mask.PRESSED; }

        enum
        Mask :ubyte {
            ENABLED = 0x1,
            PRESSED = 0x2,
        }
        //bool enabled:1;   // enabled  / disabled
        //bool unvisible:1; // visible  / unvisible
        //bool focused:1;   // focused  / 
        //bool selected:1;  // selected / 
        //bool m_over:1;    // m_over   /
        //bool defined:1;   // defined  / undefined
        //bool pressed:1;   // pressed  / released
        //bool lamp_on:1;   // lamp_on  / lamp_off

        string
        toString () {
            import std.format : format;
            return format!"Flags(%X)" (a);
        }
    }
}

struct
On (SLOTS...) {  // "name", Type, ...
    alias DG = void delegate ();

    // integrate vars
    //   Dgs pressed;
    //   Dgs released;
    static if (SLOTS.length >= 2)
    static foreach (i; 0..SLOTS.length) {
        static if (i % 2 == 0)
            mixin (SLOTS[i+1].stringof~" "~"on_"~SLOTS[i]~";");
    }

    // call on.pressed ()
    // reg  on.pressed = &wg.on_pressed;
    //struct
    //Dgs {
    //    DG[] s;

    //    void
    //    opCall () {
    //        foreach (dg; s) {
    //            dg ();
    //        }
    //    }
    //}

    void
    opDispatch (string name, ARGS...) (ARGS args) if (!name.startsWith ("on_")) {
        pragma (msg, "on.opDispatch: ", name, " ", ARGS);
        writeln ("on.opDispatch: ", name, " ", ARGS.stringof);

        static if (__traits (hasMember,typeof(this),"on_"~name)) {
            writeln ("  hasMember ", "on_"~name, " ", ARGS.stringof);
            //auto dg = __traits (getMember,this,"on_"~name);
            mixin ("auto dg = this."~"on_"~name~";");
            writeln ("  ", dg.ptr);
            if (dg.ptr !is null)
                dg (args);
        }
    }

    void
    register (T) (T t) if (is (T == class)) {
        //
    }

    void
    register (T) (T* t) if (is (T == struct)) {
        pragma (msg, "widget.on.register: ", T.stringof);
        writeln ("widget.on.register: ", T.stringof);

        static foreach (name; Functions_recursive!T) {
            static if (!__traits(isStaticFunction, __traits(getMember,T,name)))
            static if (name.startsWith ("on_")) {
                writeln ("  ",T.stringof,".", name, " ", Parameters!(__traits(getMember,T,name)).stringof);
                writeln ("  ","  hasMember in register: ",name," ",__traits (hasMember,typeof(this),name));

                // name
                // Parameters!(__traits(getMember,T,name))
                pragma (msg, "  hasMember in register: ",name," ",__traits (hasMember,typeof(this),name));
                static if (__traits (hasMember,typeof(this),name)) {
                    writeln ("  ","  this."~name~" = &t."~name~";");
                    mixin ("this."~name~" = &t."~name~";");  // delegate
                    //__traits (getMember,this,name) = &__traits(getMember,t,name);  // delegate
                }
            }
        }
    }


/* VARS2
    void
    register (T) (T* t) {
        writeln ("widget.on.register: ", T.stringof);

        DG[]* _dgs;
        static foreach (name; Functions_recursive!T) {
            static if (!__traits(isStaticFunction, __traits(getMember,T,name)))
            static if (name.startsWith ("on_")) {
                writeln ("  widget.on.", name, " ", Parameters!(__traits(getMember,T,name)).stringof);

                _dgs = _vars.var!(name,Parameters!(__traits(getMember,T,name)));
                (*_dgs) ~= cast (DG) &__traits(getMember,t,name); // delegate                    
            }
        }
    }

    void
    opDispatch (string name, ARGS...) (ARGS args) {
        pragma (msg, "widget.opDispatch: ", name, " ", ARGS);
        static if (ARGS.length)
            writeln ("  widget.on.", name, " ", ARGS.stringof, " ", args);
        else
            writeln ("  widget.on.", name, " ", ARGS.stringof);

        // delegates for name,args
        DG[]* _dgs = _vars.var!("on_"~name,ARGS) ();

        // do
        if ((*_dgs).length > 0) {
            foreach (dg; *_dgs) {
                (cast (void delegate (ARGS)) dg) (args);
            }
        }
        // info
        else {
            //assert (0, name~ " "~ ARGS.stringof~ ", no listener ");
            writeln ("  widget.on.", name, " ", ARGS.stringof, ", no listener ");
        }
    }
*/
}


//mixin template
//_Widget (Widget.Type TYPE) {
//struct {
//    Widget.Type  type;
//    Widget.Flags flags;
//    ubyte        value;
//    ubyte        reserved;
//}
//    mixin Do_switch;
//}

//mixin template
//Create () {
//    alias TWIDGET = typeof(this);

//    static
//    TWIDGET*
//    create (ARGS...) (ARGS args) {
//        auto widget = new TWIDGET (args);
//        o.hub.register (widget);
//        widget.name = TWIDGET.stringof;
//        return widget;
//    }    
//}

struct
Childs {
    Widget    parent;
    Widget[]  s;
    LAYOUT_DG layout_dg;

    alias LAYOUT_DG = void delegate (Widget widget);

    void 
    put (TWIDGET) (TWIDGET twidget) {
        s ~= /*cast (Widget) */twidget;
    }

    bool empty  () { return s.length == 0; }
    auto front  () { return s[0]; }
    auto length () { return s.length; }

    auto
    norecursive () {
        return s[];
    }
}
