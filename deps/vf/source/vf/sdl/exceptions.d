module vf.sdl.exceptions;

import std.format     : format;
import std.conv       : to;
import vf.sdl.importc : SDL_GetError;


class 
SDLException : Exception {
    this (string msg) {
        super (format!"%s: %s" (SDL_GetError().to!string, msg));
    }
}

version (SDLTTF)
class 
TTFException : Exception{
    this (string s) {
        import std.string : fromStringz;
        super (
            format!"%s: %s"(s, fromStringz(TTF_GetError()))
        );
    }
}

version (SDLImage)
class 
IMGException : Exception{
    this (string s) {
        import std.string : fromStringz;
        super (
            format!"%s: %s"(s, fromStringz(IMG_GetError()))
        );
    }
}
