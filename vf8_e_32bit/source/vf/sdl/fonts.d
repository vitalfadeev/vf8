module vf.sdl.fonts;

version (SDL):
version (SDLTTF):
import std.string : toStringz;
import vf.sdl.importc_sdl_ttf;
import vf.sdl.exceptions;


struct
Fonts {
    TTF_Font*[8] font;

    void
    _init () {
        font[0] = open_font ("res/NotoSansMNerdFont-Regular.ttf", 32);
        font[1] = open_font ("res/NotoSansMNerdFont-Regular.ttf", 16);
    }

    TTF_Font*
    open_font (string file_name, int font_size) {
        auto filez = file_name.toStringz;
        int  ptsize =font_size;
        //TTF_Font* font = TTF_OpenFont (file_name.toStringz, font_size);
        auto font = TTF_OpenFontDPI (filez, ptsize, 102, 102);
        if (font !is null)
            return font;

        throw new TTFException ("TTF_OpenFont");
    }    

}
