module vf.video;

import core.stdc.stdio  : printf;
import core.stdc.stdlib : abort;
import std.format       : format;
import std.conv         : to;
import importc;


struct
Video {
    void
    open () {    
        //init_sdl ();
        new_window_ ();
    }

    void
    close () {
        //SDL_Quit ();
    }

    SDL_Window*   window;
    SDL_Renderer* renderer;

    void
    new_window_ () {
        window   = new_window ();
        renderer = new_renderer (window);        
    }

    void
    draw () {
        // SDL_SetRenderDrawColor (renderer, 0x00, 0x00, 0x00, 0xFF);
        // SDL_RenderClear (renderer);
        // SDL_SetRenderDrawColor (renderer, 0xFF, 0xFF, 0xFF, 0xFF);
        // SDL_RenderDrawPoint (renderer, x, y);
        // SDL_RenderDrawLine (renderer,0,0,100,100);
        // SDL_RenderFillRect (renderer,&rect);
        // SDL_RenderDrawRect (renderer,&rect);
        // ...

        // Rasterize
        SDL_RenderPresent (renderer);
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
SDL_Window* 
new_window () {
    // Window
    SDL_Window* window = 
        SDL_CreateWindow (
            __FILE_FULL_PATH__, // "SDL2 Window",
            SDL_WINDOWPOS_CENTERED_DISPLAY (0),
            SDL_WINDOWPOS_CENTERED_DISPLAY (0),
            640, 480,
            SDL_WINDOW_VULKAN | 
            SDL_WINDOW_RESIZABLE | 
            SDL_WINDOW_ALLOW_HIGHDPI
        );

    if (!window)
        throw new SDLException ("Failed to create window");

    // Update
    SDL_UpdateWindowSurface (window);

    return window;
}


//
SDL_Renderer* 
new_renderer (SDL_Window* window) {
    return SDL_CreateRenderer (window, -1, SDL_RENDERER_SOFTWARE);
}


//
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
