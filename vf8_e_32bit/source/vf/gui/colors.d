module vf.gui.colors;


static __gshared Colors colors;

struct 
Colors {    
    Color[0xFF] s;
    pragma (msg, "colors.size: ", s.sizeof);  // 1_020

    ubyte
    index_of (Color a) {
        for (ubyte i=0; i<s.length; i++)
            if (s[i] == a)
                return i;
        return 0xFF;
    }
}

struct
Color {
union {
    uint _a;  // aabbggrr
struct {
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;
}
    For_SDL_Color sdl_color;
}

    this          (uint b) { _a = b; }
    void opAssign (uint b) { _a = b; }
}

struct For_SDL_Color {
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;
}
