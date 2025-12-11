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

        SDL_SetRenderDrawColor (renderer, 0x00, 0x00, 0x00, 0xFF);
        SDL_RenderClear (renderer);
        SDL_SetRenderDrawColor (renderer, 0xFF, 0xFF, 0xFF, 0xFF);
        auto rect = SDL_Rect (100,100,200,200);
        SDL_RenderDrawRect (renderer,&rect);


        //
        auto renderer = renderer; 
        auto window_surface = SDL_GetWindowSurface (window);

        auto canvas = tvg_swcanvas_create (Tvg_Engine_Option.TVG_ENGINE_OPTION_DEFAULT);
        auto sformat = window_surface.format.format;
        auto tformat = Tvg_Colorspace.TVG_COLORSPACE_ABGR8888;
        switch (sformat) {
            case SDL_PIXELFORMAT_ABGR8888: tformat = Tvg_Colorspace.TVG_COLORSPACE_ABGR8888; break;
            case SDL_PIXELFORMAT_ARGB8888: tformat = Tvg_Colorspace.TVG_COLORSPACE_ARGB8888; break;
            case SDL_PIXELFORMAT_RGB888  : tformat = Tvg_Colorspace.TVG_COLORSPACE_ARGB8888; break;
            //case SDL_PIXELFORMAT_ABGR8888: Tvg_Colorspace.TVG_COLORSPACE_ABGR8888S; break;
            //case SDL_PIXELFORMAT_ARGB8888: Tvg_Colorspace.TVG_COLORSPACE_ARGB8888S; break;
            default:
                printf ("%s\n", SDL_GetPixelFormatName (sformat));
                throw new Exception ("unknown pixel format");
        }

        tvg_swcanvas_set_target (
            canvas,
            cast (uint32_t*) window_surface.pixels, 
            window_surface.pitch, 
            window_surface.w, 
            window_surface.h, 
            tformat);

        //Set a shape
        Tvg_Paint shape1 = tvg_shape_new();
        tvg_shape_move_to(shape1, 25.0f, 25.0f);
        tvg_shape_line_to(shape1, 375.0f, 25.0f);
        tvg_shape_cubic_to(shape1, 500.0f, 100.0f, -500.0f, 200.0f, 375.0f, 375.0f);
        tvg_shape_close(shape1);

        //Prepare a gradient for the fill
        Tvg_Gradient grad = tvg_linear_gradient_new();
        tvg_linear_gradient_set(grad, 25.0f, 25.0f, 200.0f, 200.0f);
        Tvg_Color_Stop[4] color_stops = [{0.00f, 255, 0, 0, 155}, {0.33f, 0, 255, 0, 100}, {0.66f, 255, 0, 255, 100}, {1.00f, 0, 0, 255, 155}];
        tvg_gradient_set_color_stops (grad, color_stops.ptr, 4);
        tvg_gradient_set_spread(grad, TVG_STROKE_FILL_REFLECT);

        //Prepare a gradient for the stroke
        Tvg_Gradient grad_stroke = tvg_gradient_duplicate(grad);

        //Set a gradient fill
        tvg_shape_set_gradient(shape1, grad);

        //Set a gradient stroke
        tvg_shape_set_stroke_width(shape1, 20.0f);
        tvg_shape_set_stroke_gradient(shape1, grad_stroke);
        tvg_shape_set_stroke_join(shape1, TVG_STROKE_JOIN_ROUND);

        tvg_canvas_push(canvas, shape1);


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
