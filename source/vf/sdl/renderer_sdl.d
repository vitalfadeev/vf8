module vf.sdl.renderer_sdl;

version (SDL):
version (RENDERER_SDL):
import std.conv : to;
import vf.gui.color  : Color; 
import vf.sdl.importc_sdl;


struct
Renderer {
    SDL_Renderer* _renderer;

    ~this() {
        SDL_DestroyRenderer (_renderer);
    }

    void
    clear () {
        SDL_SetRenderDrawColor (_renderer, 0x00, 0x00, 0x00, 0xFF);
        SDL_RenderClear (_renderer);        
    }

    void
    draw_rect (uint x, uint y, uint w, uint h, Color fg, Color bg) {
        SDL_FRect rect;
        SDL_RenderCoordinatesFromWindow (_renderer, x,y, &rect.x,&rect.y);
        SDL_RenderCoordinatesFromWindow (_renderer, w,h, &rect.w,&rect.h);
        SDL_SetRenderDrawColor (_renderer, bg.r, bg.g, bg.b, bg.a);
        SDL_RenderFillRect (_renderer,&rect);
        SDL_SetRenderDrawColor (_renderer, fg.r, fg.g, fg.b, fg.a);
        SDL_RenderRect (_renderer,&rect);
    }

    void
    draw_text (TTF_Font* font, uint x, uint y, uint w, uint h, Color fg, Color bg, dchar[] text) {
        import vf.sdl.draw_char;
        
        if (text.length == 0) return;

        int size_w,size_h;
        auto surface = 
            _draw_text (font,x,y,w,h,fg,bg,text, &size_w,&size_h);
        scope (exit) SDL_DestroySurface (surface);

        SDL_Texture* texture = SDL_CreateTextureFromSurface (_renderer, surface);
        if (texture is null) {
            import vf.sdl.exceptions : SDLException;
            throw new SDLException ("SDL_CreateTextureFromSurface");
        }
        scope (exit) SDL_DestroyTexture (texture);

        auto centered_x = x;
        auto centered_y = y;
        if (w > size_w) centered_x += (w-size_w)/2;
        if (h > size_h) centered_y += (h-size_h)/2;

        SDL_FRect dst;
        SDL_RenderCoordinatesFromWindow (_renderer, centered_x,centered_y, &dst.x,&dst.y);
        SDL_RenderCoordinatesFromWindow (_renderer, size_w,size_h, &dst.w,&dst.h);
        SDL_RenderTexture (_renderer,texture,null,&dst);
    }

    version (SDLTTF) import vf.sdl.importc_sdl_ttf;
    SDL_Surface*
    _draw_text (TTF_Font* font, uint x, uint y, uint w, uint h, Color fg, Color bg, dchar[] text, int* size_w,  int* size_h) {
        import vf.sdl.exceptions : TTFException;

        SDL_Color sdl_fg = cast (SDL_Color) fg.sdl_color;  // struct rgba

        // TTF_RenderGlyph32_Blended
        auto surface = TTF_RenderGlyph_Blended (font,text[0],sdl_fg);
        //auto surface = TTF_RenderUNICODE_Solid (font,textz,sdl_fg);

        if (surface is null)
            throw new TTFException ("TTF_RenderUTF8_Solid");        

        int minx, maxx, miny, maxy, advance;
        TTF_GetGlyphMetrics (font,text[0], &minx, &maxx, &miny, &maxy, &advance);
        *size_w = maxx - minx;
        *size_h = maxy - miny;
        //TTF_SizeUTF8 (font,textz,size_w,size_h);

        return surface;
    }

    void
    rasterize () {
        SDL_RenderPresent (_renderer);        
    }
}
