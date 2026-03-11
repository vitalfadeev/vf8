module vf.gui.window;

version (SDL):
import vf.gui.renderer    : Renderer;
import mod.sdl_wm         : Sdl_wm;
import vf.sdl.exceptions  : SDLException;
import vf.sdl.importc_sdl;

struct
Window {
    SDL_Window* _sdl_window;

    void
    create (int x, int y, int w, int h, uint flags) {
        _sdl_window = Sdl_wm ().new_window (x,y,w,h,flags);
    }

    Renderer*
    draw_start (bool clear) {
        auto renderer = get_renderer ();
        // clear
        if (clear) {
            renderer.clear ();
        }
        return renderer;
    }

    void
    draw_end (Renderer* renderer) {
        renderer.rasterize ();
        SDL_DestroyRenderer (renderer._renderer);
        //renderer.destroy ();
    }

    Renderer* 
    get_renderer () {
        //1. opengl
        //2. opengles2
        //3. vulkan
        //4. gpu
        //5. software
        auto _sdl_renderer = SDL_CreateRenderer (_sdl_window, "opengl");
        //auto _sdl_renderer = SDL_CreateRenderer (_sdl_window, "software");
        //auto _sdl_renderer =SDL_CreateSoftwareRenderer (_sdl_window);
        if (_sdl_renderer is null) throw new SDLException ("SDL_CreateRenderer");
        return new Renderer (_sdl_renderer);
    }    
}

