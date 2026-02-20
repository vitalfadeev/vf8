module vf.sdl.renderer_sdl;

version (SDL):
import std.conv : to;
import vf.gui.colors : Color; 
import vf.sdl.fonts;
import vf.sdl.importc_sdl;


struct
Renderer {
    SDL_Renderer* _renderer;
    Fonts*         fonts;

    void
    draw_start (SDL_Event* evt) {
        SDL_Window* window = SDL_GetWindowFromID (evt.window.windowID);
        draw_start (window);
    }
    void
    draw_start (SDL_Window* window) {
        _renderer = new_renderer (window);
        SDL_SetRenderDrawColor (_renderer, 0x00, 0x00, 0x00, 0xFF);
        SDL_RenderClear (_renderer);
    }

    void
    draw_end (SDL_Event* evt) {
        SDL_Window* window = SDL_GetWindowFromID (evt.window.windowID);
        draw_end (window);
    }
    void
    draw_end (SDL_Window* window) {
        // Rasterize
        SDL_RenderPresent (_renderer);

        SDL_DestroyRenderer (_renderer);
    }

    SDL_Renderer* 
    new_renderer (SDL_Window* window) {
        return SDL_CreateRenderer (window, -1, SDL_RENDERER_SOFTWARE);
    }    

    void
    draw_rect (uint x, uint y, uint w, uint h, Color fg, Color bg) {
        auto rect = SDL_Rect (x,y,w,h);
        SDL_SetRenderDrawColor (_renderer, bg.r, bg.g, bg.b, bg.a);
        SDL_RenderFillRect (_renderer,&rect);
        SDL_SetRenderDrawColor (_renderer, fg.r, fg.g, fg.b, fg.a);
        SDL_RenderDrawRect (_renderer,&rect);
    }

    void
    draw_text (uint font_id, uint x, uint y, uint w, uint h, Color fg, Color bg, string text) {
        import vf.sdl.draw_char;
        int size_w,size_h;
        auto surface = 
            _draw_text (fonts.font[font_id],x,y,w,h,fg,bg,text, &size_w,&size_h);

        SDL_Texture* texture = SDL_CreateTextureFromSurface (_renderer, surface);
        if (texture is null) {
            import vf.sdl.exceptions : SDLException;
            throw new SDLException ("SDL_CreateTextureFromSurface");
        }

        SDL_FreeSurface (surface);

        auto centered_x = x;
        auto centered_y = y;
        if (w > size_w) centered_x += (w-size_w)/2;
        if (h > size_h) centered_y += (h-size_h)/2;

        SDL_Rect dst;
        dst.x = centered_x;
        dst.y = centered_y;
        dst.w = size_w;
        dst.h = size_h;
        SDL_RenderCopy (_renderer,texture,null,&dst);
    }

    version (SDLTTF) import vf.sdl.importc_sdl_ttf;
    SDL_Surface*
    _draw_text (TTF_Font* font, uint x, uint y, uint w, uint h, Color fg, Color bg, string text, int* size_w,  int* size_h) {
        import std.string : toStringz;
        import vf.sdl.exceptions : TTFException;

        auto textz = text.toStringz;
        SDL_Color sdl_fg = cast (SDL_Color) fg.sdl_color;  // struct rgba

        auto surface = TTF_RenderUTF8_Solid (font,textz,sdl_fg);

        if (surface is null)
            throw new TTFException ("TTF_RenderUTF8_Solid");        

        TTF_SizeUTF8 (font,textz,size_w,size_h);

        return surface;
    }
}
