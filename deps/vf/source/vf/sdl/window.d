module vf.sdl.window;

import core.stdc.stdio : printf;
import core.stdc.stdlib : abort;
import vf.sdl.exceptions : SDLException;
import vf.sdl.importc : 
    SDL_Window,SDL_Surface,SDL_Renderer,
    SDL_CreateWindow,
    SDL_UpdateWindowSurface,
    SDL_WINDOWPOS_CENTERED_DISPLAY,
    SDL_WINDOW_RESIZABLE,
    SDL_WINDOW_VULKAN,
    SDL_WINDOW_ALLOW_HIGHDPI,
    SDL_Init,SDL_INIT_VIDEO,
    SDL_GetError,
    SDL_CreateRenderer,SDL_RENDERER_SOFTWARE;

enum WINDOW_DEFAULT_W = 1024;
enum WINDOW_DEFAULT_H = 480;


struct
Window {
    void
    open () {    
        //init_sdl ();
        window = new_window ();
    }

    void
    close () {
        //SDL_Quit ();
    }

    SDL_Window*   window;
    //SDL_Renderer* renderer;

    SDL_Window* 
    new_window () {
        // Window
        SDL_Window* window = 
            SDL_CreateWindow (
                __FILE_FULL_PATH__, // "SDL2 Window",
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                SDL_WINDOWPOS_CENTERED_DISPLAY (0),
                WINDOW_DEFAULT_W, WINDOW_DEFAULT_H,
                SDL_WINDOW_RESIZABLE
                | SDL_WINDOW_VULKAN
                | SDL_WINDOW_ALLOW_HIGHDPI
            );

        if (!window)
            throw new SDLException ("Failed to create window");

        // Update
        SDL_UpdateWindowSurface (window);

        return window;
    }
}


void 
init_sdl () {
    // SDL_Init (SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS);
    if (SDL_Init (SDL_INIT_VIDEO) < 0) {
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
        if (TTF_Init () == -1)
            throw new TTFException ("Failed to initialise SDL_TTF");
    }
}

//


//
SDL_Renderer* 
new_renderer (SDL_Window* window) {
    return SDL_CreateRenderer (window, -1, SDL_RENDERER_SOFTWARE);
}
