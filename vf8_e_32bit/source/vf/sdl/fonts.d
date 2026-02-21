module vf.sdl.fonts;

version (SDL):
version (SDLTTF):
import std.string : toStringz;
import vf.sdl.importc_sdl_ttf;
import vf.sdl.exceptions;
import vf.sdl.fontconfig : Fontconfig;
import std.format : format;


struct
Fonts {
union {
    TTF_Font*[8] font;
    pragma (msg, "fonts.size: ", font.sizeof);  // 64
struct {
    TTF_Font*    xxl;
    TTF_Font*    xl;
    TTF_Font*    l;
}
}

    void
    _init () {
        //font[0] = open_font ("NotoSansMNerd-Regular", 64);
        //font[1] = open_font ("NotoSansMNerd-Regular", 32);
        //font[2] = open_font ("NotoSansMNerd-Regular", 16);
        font[0] = _open_font ("res/NotoMonoNerdFont-Regular.ttf", 64);
        font[1] = _open_font ("res/NotoMonoNerdFont-Regular.ttf", 32);
        font[2] = _open_font ("res/NotoMonoNerdFont-Regular.ttf", 16);
    }

    version (FONTCONFIG)
    TTF_Font*
    open_font (string font_name, int font_size) {
        Fontconfig fc;
        fc._init ();
        auto font_file = fc.select (format!"%s-%d" (font_name,font_size));
        return _open_font (font_file, font_size);
    }

    TTF_Font*
    _open_font (string file_name, int font_size) {
        auto filez = file_name.toStringz;
        int  ptsize =font_size;
        //TTF_Font* font = TTF_OpenFont (file_name.toStringz, font_size);
        auto font = TTF_OpenFontDPI (filez, ptsize, 102, 102);
        if (font !is null)
            return font;

        throw new TTFException ("TTF_OpenFont");
    }    

}

