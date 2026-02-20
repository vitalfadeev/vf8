module vf.sdl.window;

import vf.sdl.exceptions  : SDLException;
import vf.sdl.importc_sdl :
    SDL_Window,SDL_Surface,SDL_Renderer,
    SDL_CreateWindow,
    SDL_UpdateWindowSurface,
    SDL_WINDOWPOS_CENTERED_DISPLAY,
    SDL_WINDOW_RESIZABLE,
    SDL_WINDOW_VULKAN,
    SDL_WINDOW_ALLOW_HIGHDPI,
    SDL_GetError;

enum WINDOW_DEFAULT_W = 1024;
enum WINDOW_DEFAULT_H = 480;


struct
Window {
    SDL_Window* window;

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
                // | SDL_WINDOW_VULKAN
                // | SDL_WINDOW_ALLOW_HIGHDPI
            );

        if (!window)
            throw new SDLException ("Failed to create window");

        // Update
        SDL_UpdateWindowSurface (window);

        return window;
    }
}

