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
    //SDL_Renderer* renderer;
    static Tvg_Animation animation = null;
    auto elapsed = 0;

    void
    new_window_ () {
        window   = new_window ();
        //renderer = new_renderer (window);        
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

        //SDL_SetRenderDrawColor (renderer, 0x00, 0x00, 0x00, 0xFF);
        //SDL_RenderClear (renderer);
        //SDL_SetRenderDrawColor (renderer, 0xFF, 0xFF, 0xFF, 0xFF);
        //auto rect = SDL_Rect (100,100,200,200);
        //SDL_RenderDrawRect (renderer,&rect);

        //// Rasterize
        //SDL_RenderPresent (renderer);

        auto ptime = SDL_GetTicks();

        //
        auto surface = SDL_GetWindowSurface (window);

        auto canvas  = tvg_swcanvas_create (Tvg_Engine_Option.TVG_ENGINE_OPTION_DEFAULT);
        auto sformat = surface.format.format;
        auto tformat = Tvg_Colorspace.TVG_COLORSPACE_ABGR8888;
        switch (sformat) {
            case SDL_PIXELFORMAT_ABGR8888 : tformat = Tvg_Colorspace.TVG_COLORSPACE_ABGR8888; break;
            case SDL_PIXELFORMAT_ARGB8888 : tformat = Tvg_Colorspace.TVG_COLORSPACE_ARGB8888; break;
            case SDL_PIXELFORMAT_RGB888   : tformat = Tvg_Colorspace.TVG_COLORSPACE_ARGB8888; break;
            default:
                printf ("%s\n", SDL_GetPixelFormatName (sformat));
                throw new Exception ("unknown pixel format");
        }

        tvg_swcanvas_set_target (
            canvas, 
            cast(uint32_t*)surface.pixels, 
            surface.pitch / 4, 
            surface.w, 
            surface.h, 
            TVG_COLORSPACE_ARGB8888);

        //display the first frame
        //tvg_canvas_draw (canvas, true);
        //tvg_canvas_sync (canvas);
        //SDL_UpdateWindowSurface (window);


        // contents

        //Linear gradient shape with a linear gradient stroke
        {
            // Set a shape
            Tvg_Paint shape1 = tvg_shape_new ();
            tvg_shape_move_to (shape1, 25.0f, 25.0f);
            tvg_shape_line_to (shape1, 375.0f, 25.0f);
            tvg_shape_cubic_to (shape1, 500.0f, 100.0f, -500.0f, 200.0f, 375.0f, 375.0f);
            tvg_shape_close (shape1);

            //Prepare a gradient for the fill
            Tvg_Gradient grad = tvg_linear_gradient_new ();
            tvg_linear_gradient_set (grad, 25.0f, 25.0f, 200.0f, 200.0f);
            Tvg_Color_Stop[4] color_stops = [{0.00f, 255, 0, 0, 155}, {0.33f, 0, 255, 0, 100}, {0.66f, 255, 0, 255, 100}, {1.00f, 0, 0, 255, 155}];
            tvg_gradient_set_color_stops (grad, color_stops.ptr, 4);
            tvg_gradient_set_spread (grad, TVG_STROKE_FILL_REFLECT);

            //Prepare a gradient for the stroke
            Tvg_Gradient grad_stroke = tvg_gradient_duplicate (grad);

            //Set a gradient fill
            tvg_shape_set_gradient (shape1, grad);

            //Set a gradient stroke
            tvg_shape_set_stroke_width (shape1, 20.0f);
            tvg_shape_set_stroke_gradient (shape1, grad_stroke);
            tvg_shape_set_stroke_join (shape1, TVG_STROKE_JOIN_ROUND);

            tvg_canvas_push (canvas, shape1);
        }

        //Solid transformed shape
        {
            //Set a shape
            Tvg_Paint shape = tvg_shape_new();
            tvg_shape_move_to(shape, 25.0f, 25.0f);
            tvg_shape_line_to(shape, 375.0f, 25.0f);
            tvg_shape_cubic_to(shape, 500.0f, 100.0f, -500.0f, 200.0f, 375.0f, 375.0f);
            tvg_shape_close(shape);
            tvg_shape_set_fill_color(shape, 255, 255, 255, 128);

            //Transform a shape
            tvg_paint_scale(shape, 0.3f);
            tvg_paint_translate(shape, 100.0f, 100.0f);

            tvg_canvas_push(canvas, shape);
        }

        //Radial gradient shape with a radial dashed stroke
        {
            //Set a shape
            Tvg_Paint shape = tvg_shape_new();
            tvg_shape_append_rect(shape, 550.0f, 20.0f, 100.0f, 50.0f, 0.0f, 0.0f, true);
            tvg_shape_append_circle(shape, 600.0f, 150.0f, 100.0f, 50.0f, true);
            tvg_shape_append_rect(shape, 550.0f, 230.0f, 100.0f, 100.0f, 20.0f, 40.0f, true);

            //Prepare a radial gradient for the fill
            Tvg_Gradient grad = tvg_radial_gradient_new();
            tvg_radial_gradient_set(grad, 600.0f, 180.0f, 50.0f, 640.0f, 180.0f, 0.0f);
            Tvg_Color_Stop[3] color_stops2 = [{0.0f, 255, 0, 255, 255}, {0.5f, 0, 0, 255, 255}, {1.0f,  50,  55, 155, 255}];
            tvg_gradient_set_color_stops(grad, color_stops2.ptr, 3);
            tvg_gradient_set_spread(grad, TVG_STROKE_FILL_PAD);

            //Set a gradient fill
            tvg_shape_set_gradient(shape, grad);

            //Prepare a radial gradient for the stroke
            uint32_t cnt;
            Tvg_Color_Stop* color_stops2_get;
            tvg_gradient_get_color_stops (grad, &color_stops2_get, &cnt);

            float cx, cy, r, fx, fy, fr;
            tvg_radial_gradient_get(grad, &cx, &cy, &r, &fx, &fy, &fr);

            Tvg_Gradient grad_stroke = tvg_radial_gradient_new();
            tvg_radial_gradient_set(grad_stroke, cx, cy, r, fx, fy, fr);
            tvg_gradient_set_color_stops(grad_stroke, color_stops2_get, cnt);
            tvg_gradient_set_spread(grad_stroke, TVG_STROKE_FILL_REPEAT);

            //Set a gradient stroke
            tvg_shape_set_stroke_width(shape, 30.0f);
            tvg_shape_set_stroke_gradient(shape, grad_stroke);

            tvg_paint_set_opacity(shape, 200);

            //Push the shape into the canvas
            tvg_canvas_push(canvas, shape);
        }

        //Scene
        {
            //Set a scene
            Tvg_Paint scene = tvg_scene_new();

            //Set circles
            Tvg_Paint scene_shape1 = tvg_shape_new();
            tvg_shape_append_circle(scene_shape1, 80.0f, 650f, 40.0f, 140.0f, true);
            tvg_shape_append_circle(scene_shape1, 180.0f, 600f, 40.0f, 60.0f, true);
            tvg_shape_set_fill_color(scene_shape1, 0, 0, 255, 150);
            tvg_shape_set_stroke_color(scene_shape1, 75, 25, 155, 255);
            tvg_shape_set_stroke_width(scene_shape1, 10.0f);
            tvg_shape_set_stroke_cap(scene_shape1, Tvg_Stroke_Cap.TVG_STROKE_CAP_ROUND);
            tvg_shape_set_stroke_join(scene_shape1, Tvg_Stroke_Join.TVG_STROKE_JOIN_ROUND);
            tvg_shape_set_trimpath(scene_shape1, 0.25f, 0.75f, true);

            //Set circles with a dashed stroke
            Tvg_Paint scene_shape2 = tvg_paint_duplicate(scene_shape1);
            tvg_shape_set_fill_color(scene_shape2, 75, 25, 155, 200);

            //Prapare a dash for the stroke
            float[4] dashPattern = [15.0f, 30.0f, 2.0f, 30.0f];
            tvg_shape_set_stroke_dash(scene_shape2, dashPattern.ptr, 4, 0.0f);
            tvg_shape_set_stroke_cap(scene_shape2, TVG_STROKE_CAP_ROUND);
            tvg_shape_set_stroke_color(scene_shape2, 0, 0, 255, 255);
            tvg_shape_set_stroke_width(scene_shape2, 15.0f);

            //Transform a shape
            tvg_paint_scale(scene_shape2, 0.8f);
            tvg_paint_rotate(scene_shape2, -90.0f);
            tvg_paint_translate(scene_shape2, -200.0f, 800.0f);

            //Push the shapes into the scene
            tvg_scene_push(scene, scene_shape1);
            tvg_scene_push(scene, scene_shape2);

            //Push the scene into the canvas
            tvg_canvas_push(canvas, scene);
        }

        //Masked picture
        {
            //Set a scene
            Tvg_Paint pict = tvg_picture_new();
            if (tvg_picture_load(pict, "resources/svg/tiger.svg") != TVG_RESULT_SUCCESS) {
                printf("Problem with loading an svg file\n");
                tvg_paint_rel(pict);
            } else {
                float w, h;
                tvg_picture_get_size(pict, &w, &h);
                tvg_picture_set_size(pict, w/2, h/2);
                Tvg_Matrix m = {0.8f, 0.0f, 400.0f, 0.0f, 0.8f, 400.0f, 0.0f, 0.0f, 1.0f};
                tvg_paint_set_transform(pict, &m);

                // Set a composite shape
                Tvg_Paint comp = tvg_shape_new();
                tvg_shape_append_circle(comp, 600.0f, 600.0f, 100.0f, 100.0f, true);
                tvg_shape_set_fill_color(comp, 0, 0, 0, 200);
                tvg_paint_set_mask_method(pict, comp, TVG_MASK_METHOD_INVERSE_ALPHA);

                //Push the scene into the canvas
                tvg_canvas_push(canvas, pict);
            }
        }

        //Animation with a picture
        {
            animation = tvg_animation_new ();
            Tvg_Paint pict_lottie = tvg_animation_get_picture(animation);
            if (tvg_picture_load(pict_lottie, "resources/lottie/sample.json") != TVG_RESULT_SUCCESS) {
                printf("Problem with loading a lottie file\n");
                tvg_animation_del(animation);
                animation = null;
            } else {
                tvg_paint_scale(pict_lottie, 0.75f);
                tvg_canvas_push(canvas, pict_lottie);
            }
        }

        //Text 1
        {
            //load from a file
            if (tvg_font_load("resources/font/SentyCloud.ttf") != TVG_RESULT_SUCCESS) {
                printf("Problem with loading the font from the file. Did you enable TTF Loader?\n");
            }

            Tvg_Paint text = tvg_text_new();
            tvg_text_set_font(text, "SentyCloud");
            tvg_text_set_size(text, 25.0f);
            tvg_text_set_color(text, 200, 200, 255);
            tvg_text_set_text(text, "\xE7\xB4\xA2\xE5\xB0\x94\x56\x47\x20\xE6\x98\xAF\xE6\x9C\x80\xE5\xA5\xBD\xE7\x9A\x84");
            tvg_paint_translate(text, 50.0f, 380.0f);
            tvg_canvas_push(canvas, text);
        }

        //Text 2 with Scene effect
        {
            Tvg_Paint scene = tvg_scene_new();

            //load from a memory
            FILE* file = fopen("resources/font/Arial.ttf", "rb");
            if (file) {
                fseek(file, 0, SEEK_END);
                size_t data_size = ftell(file);
                fseek(file, 0, SEEK_SET);
                char* data = cast(char*)malloc(data_size);
                if (fread(data, 1, data_size, file) == data_size) {
                    if (tvg_font_load_data("Arial".ptr, data, data_size.to!uint, "ttf".ptr, true) != TVG_RESULT_SUCCESS) {
                        printf("Problem with loading the font file from a memory. Did you enable TTF Loader?\n");
                    }
                }
                free(data);
                fclose(file);
            }

            Tvg_Gradient grad = tvg_radial_gradient_new();
            tvg_radial_gradient_set(grad, 200.0f, 200.0f, 20.0f, 200.0f, 200.0f, 0.0f);
            Tvg_Color_Stop[2] color_stops = [{0.0f, 255, 255, 255, 255}, {1.0f, 0, 0, 255, 255}];
            tvg_gradient_set_color_stops(grad, color_stops.ptr, 2);
            tvg_gradient_set_spread(grad, TVG_STROKE_FILL_REFLECT);

            Tvg_Paint text = tvg_text_new();
            tvg_text_set_font(text, "Arial");
            tvg_text_set_size(text, 40.0f);
            tvg_text_set_outline(text, 2, 255, 0, 0);
            tvg_text_set_italic(text, 0.18f);
            tvg_text_set_gradient(text, grad);
            tvg_text_set_text(text, "ThorVG is the best");
            tvg_paint_translate(text, 20.0f, 420.0f);

            //Apply GaussianBlur post effect (sigma, direction, border option, quality)
            tvg_scene_push_effect_gaussian_blur(scene, 2.5, 0, 0, 100);
            tvg_scene_push(scene, text);

            tvg_canvas_push(canvas, scene);
        }


        //update the animation
        if (animation) {
            float duration, totalFrame;
            tvg_animation_get_duration(animation, &duration);
            tvg_animation_get_total_frame(animation, &totalFrame);
            tvg_animation_set_frame(animation, totalFrame * progress(elapsed, duration));
        }

        //
        auto ctime = SDL_GetTicks();
        elapsed += (ctime - ptime);
        ptime = ctime;

        


        //draw the canvas
        tvg_canvas_update (canvas);
        tvg_canvas_draw (canvas, true);
        tvg_canvas_sync (canvas);

        SDL_UpdateWindowSurface (window);
    }

    float 
    progress (uint32_t elapsed, float durationInSec) {
        auto duration = (durationInSec * 1000.0f).to!uint32_t; //sec -> millisec.
        auto clamped = elapsed % duration;
        return (cast(float)clamped / cast(float)duration);
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
            800, 600,
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
