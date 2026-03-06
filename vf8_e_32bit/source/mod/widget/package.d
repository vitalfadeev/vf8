module mod.widget;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import mod.widget.button;
//import mod.widget.volume;
import mod.volume;
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
import vf.gui.style : Style;
import vf.gui.page : Page;
import vf.sdl.renderer_sdl : Renderer;

struct
Widget {
    Widget.Flags flags;  
    ubyte        value;
    ubyte        reserved;
    string       name;  // for find style
    Xywh         xywh;
    Page*        page;
    DRAW_DG      draw_dg;

    alias DRAW_DG = void delegate (Style* style, Renderer* renderer);

    void 
    _draw (Style* style, Renderer* renderer) {
        writeln ("default DRAW on widget");
    };


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
