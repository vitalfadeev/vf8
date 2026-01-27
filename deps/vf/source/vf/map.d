module vf.map;

import vf.types;


struct
Map_rec {
    TYP type; // SDL_KEYDOWN
    KEY key;  // SDLK_ESCAPE
    GO  go;
}

import importc;
void
process_map (Event) (void* o, void* e, Event* evt, REG d,  size_t map_length, Map_rec* map_ptr) {
    REG  _key;
    auto _type = evt.sdl.sdl_event.type;

    with (evt.sdl.sdl_event)
    switch (type)  {
        case SDL_KEYDOWN     : _key = key.keysym.sym; break;
        case SDL_KEYUP       : _key = key.keysym.sym; break;
        case SDL_WINDOWEVENT : _key = window.event; break;
        default: 
    }

    auto RCX = map_length;
    auto rec = map_ptr;
    for (; RCX != 0; rec++, RCX--)
        if (rec.type == _type)
            if (rec.key == _key)
                rec.go (o,e,evt,d);
}

alias TYP = REG;
alias KEY = REG;


//
void
GO_map (Event,Triads...) (void* o, void* e, Event* evt, REG d) {
    alias _array = GO_map_array!Triads;  // [Rec (Key,Value), ...]
    
    static Map_rec[ _array.length ] map = _array;

    process_map (o,e,evt,d, map.length, map.ptr);
}

template
GO_map_array (Triads...) {
    enum GO_map_array = [GO_map_array_init!(Triads).result];
}

template 
GO_map_array_init (Triads...) {
    import std.meta : AliasSeq;

    static if (Triads.length == 0)
    {
        // Базовый случай: пустой набор
        enum result = AliasSeq!();
    }
    else static if (Triads.length >= 3)
    {
        alias Typ   = Triads[0];
        alias Key   = Triads[1];
        alias Value = Triads[2];

        // Рекурсивно обрабатываем оставшиеся пары
        enum rest   = GO_map_array_init!(Triads[3 .. $]).result;
        enum result = AliasSeq!(Map_rec (Typ,Key,&Value), rest);
    }
    else
    {
        static assert(0, "Количество элементов в AliasSeq должно быть 3");
    }
}

