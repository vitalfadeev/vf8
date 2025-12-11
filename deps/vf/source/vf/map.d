module vf.map;

import vf.types;


struct
Map_rec {
    TYP type; // SDL_KEYDOWN
    KEY key;  // SDLK_ESCAPE
    GO  go;
}

import vf.input : Event;
import importc;
void
process_map (void* o, void* e, void* evt, REG d,  size_t map_length, Map_rec* map_ptr) {
    auto _evt = cast (Event*) evt;
    REG   typ = d;
    REG   key;

    switch (typ) {
        case SDL_KEYDOWN     : key = _evt.key.keysym.sym; break;
        case SDL_KEYUP       : key = _evt.key.keysym.sym; break;
        case SDL_WINDOWEVENT : key = _evt.window.event; break;
        default: 
    }

    auto RCX = map_length;
    auto rec = map_ptr;
    for (; RCX != 0; rec++, RCX--)
        if (typ == rec.type)
            if (key == rec.key)
                rec.go (o,e,evt,d);
}

alias TYP = REG;
alias KEY = REG;


//
void
GO_map (Pairs...) (void* o, void* e, void* evt, REG d) {
    alias _array = GO_map_array!Pairs;  // [Rec (Key,Value), ...]
    
    static Map_rec[ _array.length ] map = _array;

    process_map (o,e,evt,d, map.length, map.ptr);
}

template
GO_map_array (Pairs...) {
    enum GO_map_array = [GO_map_array_init!(Pairs).result];
}

template 
GO_map_array_init (Pairs...) {
    import std.meta : AliasSeq;

    static if (Pairs.length == 0)
    {
        // Базовый случай: пустой набор
        enum result = AliasSeq!();
    }
    else static if (Pairs.length >= 3)
    {
        alias Typ   = Pairs[0];
        alias Key   = Pairs[1];
        alias Value = Pairs[2];

        // Рекурсивно обрабатываем оставшиеся пары
        enum rest   = GO_map_array_init!(Pairs[3 .. $]).result;
        enum result = AliasSeq!(Map_rec (Typ,Key,&Value), rest);
    }
    else
    {
        static assert(0, "Количество элементов в AliasSeq должно быть 3");
    }
}

