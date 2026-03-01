module mod.widget;

version (SDL):
import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import mod.widget.button;
//import mod.widget.volume;
import mod.volume;


struct
Mod_widget {    
    void
    do_switch (Event* evt) {
        switch (evt.sdl.type) with (SDL_EventType) {
            case SDL_MOUSEBUTTONDOWN : _do_sdl_button (evt); break;
            case SDL_MOUSEBUTTONUP   : _do_sdl_button (evt); break;
            default                  :
        }
    }

    void
    _do_sdl_button (Event* evt) {
        import vf.sdl.importc_sdl;

        with (evt.o)
        with (Event.Type)
        with (evt.sdl.button) {
            auto xy = XY (x,y);
            // widgets at xy
            foreach (i,xywh; page.layout.select (xy)) {
                auto widget = page.widgets.s[i];
                evt.i      = i;
                evt.xywh   = xywh;
                evt.widget = widget;
                widget.do_switch (evt);
                
                send (REDRAW, windowID, null, xywh);
            }
        }
    }
}

import importc_sdl;
import app;

struct
Widget {
    DO_SWITCH   _do_switch;
    Widget.Flags flags;
    ubyte        value;
    ubyte        reserved;
    string       name;

    alias DO_SWITCH = void delegate (Event* evt);

    void
    do_switch (Event* evt) {
        assert(_do_switch !is null);
        _do_switch (evt);
    }
    
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

mixin template
Create () {
    alias TWIDGET = typeof(this);
    static
    TWIDGET*
    create (ARGS...) (ARGS args) {
        auto widget = new TWIDGET (args);
        widget._do_switch = &widget.do_switch;
        widget.name = TWIDGET.stringof;
        return widget;
    }    
}


mixin template
Do_switch () {
    import mod.widget;
    import app=app;
    import importc_sdl=vf.sdl.importc_sdl;
    mixin Switch!(importc_sdl.SDL_EventType, app.Event.Type);
}

mixin template
Switch (ET1,ET2) {
    alias T   = typeof (this);

    //void
    //do_switch (Event* evt) {
    //    switch (evt.type) with (SDL_EventType) {
    //        case SDL_MOUSEBUTTONDOWN : _do_sdl_button (evt); break;
    //        case SDL_MOUSEBUTTONUP   : _do_sdl_button (evt); break;
    //        default                  :
    //    }
    //}

    void 
    do_switch (Event* evt) {
        bool _was;

        mixin (_Switch!(typeof(this),ET1));
        mixin (_Switch!(typeof(this),ET2));

        static if (__traits (hasMember,T,"_super"))
        static if (!is(typeof(T._super) == Widget))
            if (!_was) _super.do_switch (evt);
    }
}

import std.traits;
import std.meta;
import std.format;

string
_Switch (T,EVENT_TYPE) () {
    string s;

static if (EnumFunctions!(EVENT_TYPE,Functions!T)) {
    s = "
        switch (evt.type) {";
        foreach (fn_name; Functions!T)
            if (isEnumMember!(EVENT_TYPE, fn_name))
    s ~= format!"
            case %s.%s : %s (evt); _was=true; break;" ((fullyQualifiedName!EVENT_TYPE), fn_name, fn_name);
    s ~= "
            default                  :
        }
    ";
}

    return s;
}

template
Functions (alias T) {
    alias Functions = _Functions!(T,__traits(allMembers, T));
}

template
_Functions (T,MEMBERS...) {
    static if (MEMBERS.length == 0) {
        alias _Functions = AliasSeq!();
    }
    static if (MEMBERS.length == 1) {
        enum  memberName = MEMBERS[0];
        alias member     = __traits(getMember, T, memberName);

        static if (is(typeof(member) == function)) {
            alias _Functions =  AliasSeq!(memberName);
        } else {
            alias _Functions =  AliasSeq!();
        }
    }
    static if (MEMBERS.length > 1) {
        enum  memberName = MEMBERS[0];
        alias member     = __traits(getMember, T, memberName);
        alias rest       = _Functions!(T,MEMBERS[1..$]);

        static if (is(typeof(member) == function)) {
            alias _Functions =  AliasSeq!(memberName,rest);
        } else {
            alias _Functions =  AliasSeq!(rest);
        }
    }
}

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
