module vf.sdl.init_sdl;

import core.stdc.stdio    : printf;
import core.stdc.stdlib   : abort;
import vf.sdl.exceptions  : SDLException;
import vf.sdl.importc_sdl;

void 
init_sdl () {
    // SDL_Init (SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_EVERYTHING);
    if (SDL_Init (SDL_INIT_VIDEO | SDL_INIT_EVENTS) < 0) {
        printf ("Failed to initialize SDL video: %s\n", SDL_GetError ());
        abort ();
    }

    // IMG
    version (SDLImage) {
        auto flags = IMG_INIT_PNG | IMG_INIT_JPG;
        if (IMG_Init (flags) != flags)
            throw new IMGException ("The SDL_Image init failed");
    }

    // TTF
    version (SDLTTF) {
        import vf.sdl.importc_sdl_ttf : TTF_Init;
        import vf.sdl.exceptions      : TTFException;
        if (TTF_Init () == -1)
            throw new TTFException ("Failed to initialise SDL_TTF");
    }
}
