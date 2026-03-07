module mod.widget;

version (SDL):
import vf.std.xywh;
import vf.gui.color  : Color;
import vf.sdl.importc_sdl;
import app : o;


struct
Mod_widget {
    void
    SDL_BUTTON (SDL_MouseButtonEvent* evt) {
        with (evt) {
            //
        }
        //_select_and_call_widget (evt,x,y,windowID);
    }

    void
    SDL_MOUSEWHEEL (SDL_MouseWheelEvent* evt) {
        with (evt) {
            //
        }
    }
}

import importc_sdl;
import app;
import vf.sdl.renderer_sdl : Renderer;
import std.stdio : writeln;
import vf.gui.page : Page;
import vf.sdl.renderer_sdl : Renderer;

struct
Widget {
    Xywh     xywh;
    Flags    flags;  
    Page*    page;
    string   name;  // for debug
    // style
    Color    fg;
    Color    bg;
    dchar[]  text;
    dchar[]  text_set;
    Image    image;
    Image    image_set;
    STYLE_DG style_dg;
    DRAW_DG  draw_dg;
    // childs
    Childs   childs;

    alias STYLE_DG = void delegate ();
    alias DRAW_DG  = void delegate (Renderer*);

    struct
    Image {
        size_t length;
        void*  ptr;
    }

    void
    style () {
        //
    }    

    void 
    draw (Renderer* renderer) {
        if (style_dg !is null) style_dg ();

        writeln ("default draw on widget");
    };

    auto
    recursive () {
        return Recursive (&this);
    }

    import std.range;   
    struct
    Recursive {  // in deep
        Widget* front;
        Widget*[][] childs_ranges;
        Widget* _next;
        bool    empty () { 
            return (front is null);
        }
        void    popFront () { front = next (); }
        auto    next () {
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

import vf.std.traits : Functions;

//void 
//_All_members_recucsive(T)() {
//    // 1. Собственные члены структуры
//    alias _members = __traits(allMembers, T);

//    // 2. Члены из alias this
//    static foreach (aliasName; __traits(getAliasThis, T)) {
//        // Получаем тип поля, через которое сделан alias this
//        alias AliasType = typeof(__traits(getMember, T.init, aliasName));
        
//        static if (is(AliasType == struct) || is(AliasType == class)) {
//            AliasSeq!(_members,);
//            writeln("--- From alias this (", aliasName, "): ---");
//            printAllMembers!AliasType(); // Рекурсивный вызов
//        }
//    }
//}


template 
isEnumMember (alias T, alias member) {
    static bool isEnumMember () {
        foreach(m; __traits(allMembers, T)) {
            static if (m == member) {
                return true;
            }
        }
        return false;
    }
}

template
EnumFunctions (alias EVENT_TYPE, FUNCTIONS...) {
    static bool EnumFunctions () {
        foreach (fn_name; FUNCTIONS) {
            static if (isEnumMember!(EVENT_TYPE, fn_name)) {
                return true;
            }
        }
        return false;
    }
}


struct
Childs {
    Widget*   parent;
    Widget*[] s;
    LAYOUT_DG layout_dg;

    alias LAYOUT_DG = void delegate (Widget* widget);

    void 
    put (TWIDGET) (TWIDGET* twidget) {
        s ~= cast (Widget*) twidget;
    }

    bool empty  () { return s.length == 0; }
    auto front  () { return s[0]; }
    auto length () { return s.length; }

    auto
    norecursive () {
        return s[];
    }
}

