module bindbc.thorvg.bind.thorvg;

import bindbc.thorvg.config;
import bindbc.thorvg.bind.types;

static if (staticBinding)
{
    extern(C) @nogc nothrow
    {
        //************************************************************************/
        //* Engine API                                                           */
        //************************************************************************/
        Tvg_Result tvg_engine_init(Tvg_Engine engine_method, uint threads);
        Tvg_Result tvg_engine_term(Tvg_Engine engine_method);
        //************************************************************************/
        //* SwCanvas API                                                         */
        //************************************************************************/
        Tvg_Canvas* tvg_swcanvas_create();
        Tvg_Result tvg_swcanvas_set_target(Tvg_Canvas* canvas, uint* buffer, uint stride, uint w, uint h, Tvg_Colorspace cs);
        Tvg_Result tvg_swcanvas_set_mempool(Tvg_Canvas* canvas, Tvg_Mempool_Policy policy);
        //************************************************************************/
        //* Common Canvas API                                                    */
        //************************************************************************/
        Tvg_Result tvg_canvas_destroy(Tvg_Canvas* canvas);
        Tvg_Result tvg_canvas_push(Tvg_Canvas* canvas, Tvg_Paint* paint);
        Tvg_Result tvg_canvas_reserve(Tvg_Canvas* canvas, uint n);
        Tvg_Result tvg_canvas_clear(Tvg_Canvas* canvas, bool free);
        Tvg_Result tvg_canvas_update(Tvg_Canvas* canvas);
        Tvg_Result tvg_canvas_update_paint(Tvg_Canvas* canvas, Tvg_Paint* paint);
        Tvg_Result tvg_canvas_draw(Tvg_Canvas* canvas);
        Tvg_Result tvg_canvas_sync(Tvg_Canvas* canvas);
        //************************************************************************/
        //* Paint API                                                            */
        //************************************************************************/
        Tvg_Result tvg_paint_del(Tvg_Paint* paint);
        Tvg_Result tvg_paint_scale(Tvg_Paint* paint, float factor);
        Tvg_Result tvg_paint_rotate(Tvg_Paint* paint, float degree);
        Tvg_Result tvg_paint_translate(Tvg_Paint* paint, float x, float y);
        Tvg_Result tvg_paint_set_transform(Tvg_Paint* paint, const Tvg_Matrix* m);
        Tvg_Result tvg_paint_get_transform(Tvg_Paint* paint, Tvg_Matrix* m);
        Tvg_Result tvg_paint_set_opacity(Tvg_Paint* paint, ubyte opacity);
        Tvg_Result tvg_paint_get_opacity(const Tvg_Paint* paint, ubyte* opacity);
        Tvg_Paint* tvg_paint_duplicate(Tvg_Paint* paint);
        Tvg_Result tvg_paint_get_bounds(const Tvg_Paint* paint, float* x, float* y, float* w, float* h, bool transformed);
        Tvg_Result tvg_paint_set_composite_method(Tvg_Paint* paint, Tvg_Paint* target, Tvg_Composite_Method method);
        Tvg_Result tvg_paint_get_composite_method(const Tvg_Paint* paint, const Tvg_Paint** target, Tvg_Composite_Method* method);
        static if (tvgSupport >= TVGSupport.v0_9)
        {
            Tvg_Result tvg_paint_get_identifier(const Tvg_Paint* paint, Tvg_Identifier* identifier);
        }
        //************************************************************************/
        //* Shape API                                                            */
        //************************************************************************/
        Tvg_Paint* tvg_shape_new();
        Tvg_Result tvg_shape_reset(Tvg_Paint* paint);
        Tvg_Result tvg_shape_move_to(Tvg_Paint* paint, float x, float y);
        Tvg_Result tvg_shape_line_to(Tvg_Paint* paint, float x, float y);
        Tvg_Result tvg_shape_cubic_to(Tvg_Paint* paint, float cx1, float cy1, float cx2, float cy2, float x, float y);
        Tvg_Result tvg_shape_close(Tvg_Paint* paint);
        Tvg_Result tvg_shape_append_rect(Tvg_Paint* paint, float x, float y, float w, float h, float rx, float ry);
        Tvg_Result tvg_shape_append_circle(Tvg_Paint* paint, float cx, float cy, float rx, float ry);
        Tvg_Result tvg_shape_append_arc(Tvg_Paint* paint, float cx, float cy, float radius, float startAngle, float sweep, ubyte pie);
        Tvg_Result tvg_shape_append_path(Tvg_Paint* paint, const Tvg_Path_Command* cmds, uint cmdCnt, const Tvg_Point* pts, uint ptsCnt);
        Tvg_Result tvg_shape_get_path_coords(const Tvg_Paint* paint, const Tvg_Point** pts, uint* cnt);
        Tvg_Result tvg_shape_get_path_commands(const Tvg_Paint* paint, const Tvg_Path_Command** cmds, uint* cnt);
        Tvg_Result tvg_shape_set_stroke_width(Tvg_Paint* paint, float width);
        Tvg_Result tvg_shape_get_stroke_width(const Tvg_Paint* paint, float* width);
        Tvg_Result tvg_shape_set_stroke_color(Tvg_Paint* paint, ubyte r, ubyte g, ubyte b, ubyte a);
        Tvg_Result tvg_shape_get_stroke_color(const Tvg_Paint* paint, ubyte* r, ubyte* g, ubyte* b, ubyte* a);
        Tvg_Result tvg_shape_set_stroke_linear_gradient(Tvg_Paint* paint, Tvg_Gradient* grad);
        Tvg_Result tvg_shape_set_stroke_radial_gradient(Tvg_Paint* paint, Tvg_Gradient* grad);
        Tvg_Result tvg_shape_get_stroke_gradient(const Tvg_Paint* paint, Tvg_Gradient** grad);
        Tvg_Result tvg_shape_set_stroke_dash(Tvg_Paint* paint, const float* dashPattern, uint cnt);
        Tvg_Result tvg_shape_get_stroke_dash(const Tvg_Paint* paint, const float** dashPattern, uint* cnt);
        Tvg_Result tvg_shape_set_stroke_cap(Tvg_Paint* paint, Tvg_Stroke_Cap cap);
        Tvg_Result tvg_shape_get_stroke_cap(const Tvg_Paint* paint, Tvg_Stroke_Cap* cap);
        Tvg_Result tvg_shape_set_stroke_join(Tvg_Paint* paint, Tvg_Stroke_Join join);
        Tvg_Result tvg_shape_get_stroke_join(const Tvg_Paint* paint, Tvg_Stroke_Join* join);
        static if (tvgSupport >= TVGSupport.v0_10)
        {
            Tvg_Result tvg_shape_set_stroke_miterlimit(Tvg_Paint* paint, float miterlimit);
            Tvg_Result tvg_shape_get_stroke_miterlimit(const Tvg_Paint* paint, float* miterlimit);
        }
        Tvg_Result tvg_shape_set_fill_color(Tvg_Paint* paint, ubyte r, ubyte g, ubyte b, ubyte a);
        Tvg_Result tvg_shape_get_fill_color(const Tvg_Paint* paint, ubyte* r, ubyte* g, ubyte* b, ubyte* a);
        Tvg_Result tvg_shape_set_fill_rule(Tvg_Paint* paint, Tvg_Fill_Rule rule);
        Tvg_Result tvg_shape_get_fill_rule(const Tvg_Paint* paint, Tvg_Fill_Rule* rule);
        static if (tvgSupport >= TVGSupport.v0_10)
        {
            Tvg_Result tvg_shape_set_paint_order(const Tvg_Paint* paint, bool strokeFirst);
        }
        Tvg_Result tvg_shape_set_linear_gradient(Tvg_Paint* paint, Tvg_Gradient* grad);
        Tvg_Result tvg_shape_set_radial_gradient(Tvg_Paint* paint, Tvg_Gradient* grad);
        Tvg_Result tvg_shape_get_gradient(const Tvg_Paint* paint, Tvg_Gradient** grad);

        Tvg_Gradient* tvg_linear_gradient_new();
        Tvg_Gradient* tvg_radial_gradient_new();
        Tvg_Result tvg_linear_gradient_set(Tvg_Gradient* grad, float x1, float y1, float x2, float y2);
        Tvg_Result tvg_linear_gradient_get(Tvg_Gradient* grad, float* x1, float* y1, float* x2, float* y2);
        Tvg_Result tvg_radial_gradient_set(Tvg_Gradient* grad, float cx, float cy, float radius);
        Tvg_Result tvg_radial_gradient_get(Tvg_Gradient* grad, float* cx, float* cy, float* radius);
        Tvg_Result tvg_gradient_set_color_stops(Tvg_Gradient* grad, const Tvg_Color_Stop* color_stop, uint cnt);
        Tvg_Result tvg_gradient_get_color_stops(const Tvg_Gradient* grad, const Tvg_Color_Stop** color_stop, uint* cnt);
        Tvg_Result tvg_gradient_set_spread(Tvg_Gradient* grad, const Tvg_Stroke_Fill spread);
        Tvg_Result tvg_gradient_get_spread(const Tvg_Gradient* grad, Tvg_Stroke_Fill* spread);
        Tvg_Result tvg_gradient_set_transform(Tvg_Gradient* grad, const Tvg_Matrix* m);
        Tvg_Result tvg_gradient_get_transform(const Tvg_Gradient* grad, Tvg_Matrix* m);
        static if (tvgSupport >= TVGSupport.v0_9)
        {
            Tvg_Result tvg_gradient_get_identifier(const Tvg_Gradient* grad, Tvg_Identifier* identifier);
        }
        Tvg_Gradient* tvg_gradient_duplicate(Tvg_Gradient* grad);
        Tvg_Result tvg_gradient_del(Tvg_Gradient* grad);
        //************************************************************************/
        //* Picture API                                                          */
        //************************************************************************/
        Tvg_Paint* tvg_picture_new();
        Tvg_Result tvg_picture_load(Tvg_Paint* paint, const char* path);
        Tvg_Result tvg_picture_load_raw(Tvg_Paint* paint, uint *data, uint w, uint h, bool copy);
        Tvg_Result tvg_picture_load_data(Tvg_Paint* paint, const char *data, uint size, const char *mimetype, bool copy);
        Tvg_Result tvg_picture_set_size(Tvg_Paint* paint, float w, float h);
        Tvg_Result tvg_picture_get_size(const Tvg_Paint* paint, float* w, float* h);
        static if (tvgSupport < TVGSupport.v0_10)
        {
            Tvg_Result tvg_picture_get_viewbox(const Tvg_Paint* paint, float* x, float* y, float* w, float* h);
        }

        Tvg_Paint* tvg_scene_new();
        Tvg_Result tvg_scene_reserve(Tvg_Paint* scene, uint size);
        Tvg_Result tvg_scene_push(Tvg_Paint* scene, Tvg_Paint* paint);
        Tvg_Result tvg_scene_clear(Tvg_Paint* scene, bool free);
        //************************************************************************/
        //* Saver API                                                            */
        //************************************************************************/
        Tvg_Saver* tvg_saver_new();
        Tvg_Result tvg_saver_save(Tvg_Saver* saver, Tvg_Paint* paint, const char* path, bool compress);
        Tvg_Result tvg_saver_sync(Tvg_Saver* saver);
        Tvg_Result tvg_saver_del(Tvg_Saver* saver);
    }
}
else
{
    extern(C) @nogc nothrow
    {

        //************************************************************************/
        //* Engine API                                                           */
        //************************************************************************/
        alias ptvg_engine_init = Tvg_Result function(Tvg_Engine engine_method, uint threads);
        alias ptvg_engine_term = Tvg_Result function(Tvg_Engine engine_method);
        //************************************************************************/
        //* SwCanvas API                                                         */
        //************************************************************************/
        alias ptvg_swcanvas_create = Tvg_Canvas* function();
        alias ptvg_swcanvas_set_target = Tvg_Result function(Tvg_Canvas* canvas, uint* buffer, uint stride, uint w, uint h, Tvg_Colorspace cs);
        alias ptvg_swcanvas_set_mempool = Tvg_Result function(Tvg_Canvas* canvas, Tvg_Mempool_Policy policy);
        //************************************************************************/
        //* Common Canvas API                                                    */
        //************************************************************************/
        alias ptvg_canvas_destroy = Tvg_Result function(Tvg_Canvas* canvas);
        alias ptvg_canvas_push = Tvg_Result function(Tvg_Canvas* canvas, Tvg_Paint* paint);
        alias ptvg_canvas_reserve = Tvg_Result function(Tvg_Canvas* canvas, uint n);
        alias ptvg_canvas_clear = Tvg_Result function(Tvg_Canvas* canvas, bool free);
        alias ptvg_canvas_update = Tvg_Result function(Tvg_Canvas* canvas);
        alias ptvg_canvas_update_paint = Tvg_Result function(Tvg_Canvas* canvas, Tvg_Paint* paint);
        alias ptvg_canvas_draw = Tvg_Result function(Tvg_Canvas* canvas);
        alias ptvg_canvas_sync = Tvg_Result function(Tvg_Canvas* canvas);
        //************************************************************************/
        //* Paint API                                                            */
        //************************************************************************/
        alias ptvg_paint_del = Tvg_Result function(Tvg_Paint* paint);
        alias ptvg_paint_scale = Tvg_Result function(Tvg_Paint* paint, float factor);
        alias ptvg_paint_rotate = Tvg_Result function(Tvg_Paint* paint, float degree);
        alias ptvg_paint_translate = Tvg_Result function(Tvg_Paint* paint, float x, float y);
        alias ptvg_paint_set_transform = Tvg_Result function(Tvg_Paint* paint, const Tvg_Matrix* m);
        alias ptvg_paint_get_transform = Tvg_Result function(Tvg_Paint* paint, Tvg_Matrix* m);
        alias ptvg_paint_set_opacity = Tvg_Result function(Tvg_Paint* paint, ubyte opacity);
        alias ptvg_paint_get_opacity = Tvg_Result function(const Tvg_Paint* paint, ubyte* opacity);
        alias ptvg_paint_duplicate = Tvg_Paint* function(Tvg_Paint* paint);
        alias ptvg_paint_get_bounds = Tvg_Result function(const Tvg_Paint* paint, float* x, float* y, float* w, float* h, bool transformed);
        alias ptvg_paint_set_composite_method = Tvg_Result function(Tvg_Paint* paint, Tvg_Paint* target, Tvg_Composite_Method method);
        alias ptvg_paint_get_composite_method = Tvg_Result function(const Tvg_Paint* paint, const Tvg_Paint** target, Tvg_Composite_Method* method);
        static if (tvgSupport >= TVGSupport.v0_9)
        {
            alias ptvg_paint_get_identifier = Tvg_Result function(const Tvg_Paint* paint, Tvg_Identifier* identifier);
        }
        //************************************************************************/
        //* Shape API                                                            */
        //************************************************************************/
        alias ptvg_shape_new = Tvg_Paint* function();
        alias ptvg_shape_reset = Tvg_Result function(Tvg_Paint* paint);
        alias ptvg_shape_move_to = Tvg_Result function(Tvg_Paint* paint, float x, float y);
        alias ptvg_shape_line_to = Tvg_Result function(Tvg_Paint* paint, float x, float y);
        alias ptvg_shape_cubic_to = Tvg_Result function(Tvg_Paint* paint, float cx1, float cy1, float cx2, float cy2, float x, float y);
        alias ptvg_shape_close = Tvg_Result function(Tvg_Paint* paint);
        alias ptvg_shape_append_rect = Tvg_Result function(Tvg_Paint* paint, float x, float y, float w, float h, float rx, float ry);
        alias ptvg_shape_append_circle = Tvg_Result function(Tvg_Paint* paint, float cx, float cy, float rx, float ry);
        alias ptvg_shape_append_arc = Tvg_Result function(Tvg_Paint* paint, float cx, float cy, float radius, float startAngle, float sweep, ubyte pie);
        alias ptvg_shape_append_path = Tvg_Result function(Tvg_Paint* paint, const Tvg_Path_Command* cmds, uint cmdCnt, const Tvg_Point* pts, uint ptsCnt);
        alias ptvg_shape_get_path_coords = Tvg_Result function(const Tvg_Paint* paint, const Tvg_Point** pts, uint* cnt);
        alias ptvg_shape_get_path_commands = Tvg_Result function(const Tvg_Paint* paint, const Tvg_Path_Command** cmds, uint* cnt);
        alias ptvg_shape_set_stroke_width = Tvg_Result function(Tvg_Paint* paint, float width);
        alias ptvg_shape_get_stroke_width = Tvg_Result function(const Tvg_Paint* paint, float* width);
        alias ptvg_shape_set_stroke_color = Tvg_Result function(Tvg_Paint* paint, ubyte r, ubyte g, ubyte b, ubyte a);
        alias ptvg_shape_get_stroke_color = Tvg_Result function(const Tvg_Paint* paint, ubyte* r, ubyte* g, ubyte* b, ubyte* a);
        alias ptvg_shape_set_stroke_linear_gradient = Tvg_Result function(Tvg_Paint* paint, Tvg_Gradient* grad);
        alias ptvg_shape_set_stroke_radial_gradient = Tvg_Result function(Tvg_Paint* paint, Tvg_Gradient* grad);
        alias ptvg_shape_get_stroke_gradient = Tvg_Result function(const Tvg_Paint* paint, Tvg_Gradient** grad);
        alias ptvg_shape_set_stroke_dash = Tvg_Result function(Tvg_Paint* paint, const float* dashPattern, uint cnt);
        alias ptvg_shape_get_stroke_dash = Tvg_Result function(const Tvg_Paint* paint, const float** dashPattern, uint* cnt);
        alias ptvg_shape_set_stroke_cap = Tvg_Result function(Tvg_Paint* paint, Tvg_Stroke_Cap cap);
        alias ptvg_shape_get_stroke_cap = Tvg_Result function(const Tvg_Paint* paint, Tvg_Stroke_Cap* cap);
        alias ptvg_shape_set_stroke_join = Tvg_Result function(Tvg_Paint* paint, Tvg_Stroke_Join join);
        alias ptvg_shape_get_stroke_join = Tvg_Result function(const Tvg_Paint* paint, Tvg_Stroke_Join* join);
        static if (tvgSupport >= TVGSupport.v0_10)
        {
            alias ptvg_shape_set_stroke_miterlimit = Tvg_Result function(Tvg_Paint* paint, float miterlimit);
            alias ptvg_shape_get_stroke_miterlimit = Tvg_Result function(const Tvg_Paint* paint, float* miterlimit);
        }
        alias ptvg_shape_set_fill_color = Tvg_Result function(Tvg_Paint* paint, ubyte r, ubyte g, ubyte b, ubyte a);
        alias ptvg_shape_get_fill_color = Tvg_Result function(const Tvg_Paint* paint, ubyte* r, ubyte* g, ubyte* b, ubyte* a);
        alias ptvg_shape_set_fill_rule = Tvg_Result function(Tvg_Paint* paint, Tvg_Fill_Rule rule);
        alias ptvg_shape_get_fill_rule = Tvg_Result function(const Tvg_Paint* paint, Tvg_Fill_Rule* rule);
        static if (tvgSupport >= TVGSupport.v0_10)
        {
            alias ptvg_shape_set_paint_order = TvgResult function(Tvg_Paint* paint, bool strokeFirst);
        }
        alias ptvg_shape_set_linear_gradient = Tvg_Result function(Tvg_Paint* paint, Tvg_Gradient* grad);
        alias ptvg_shape_set_radial_gradient = Tvg_Result function(Tvg_Paint* paint, Tvg_Gradient* grad);
        alias ptvg_shape_get_gradient = Tvg_Result function(const Tvg_Paint* paint, Tvg_Gradient** grad);

        alias ptvg_linear_gradient_new = Tvg_Gradient* function();
        alias ptvg_radial_gradient_new = Tvg_Gradient* function();
        alias ptvg_linear_gradient_set = Tvg_Result function(Tvg_Gradient* grad, float x1, float y1, float x2, float y2);
        alias ptvg_linear_gradient_get = Tvg_Result function(Tvg_Gradient* grad, float* x1, float* y1, float* x2, float* y2);
        alias ptvg_radial_gradient_set = Tvg_Result function(Tvg_Gradient* grad, float cx, float cy, float radius);
        alias ptvg_radial_gradient_get = Tvg_Result function(Tvg_Gradient* grad, float* cx, float* cy, float* radius);
        alias ptvg_gradient_set_color_stops = Tvg_Result function(Tvg_Gradient* grad, const Tvg_Color_Stop* color_stop, uint cnt);
        alias ptvg_gradient_get_color_stops = Tvg_Result function(const Tvg_Gradient* grad, const Tvg_Color_Stop** color_stop, uint* cnt);
        alias ptvg_gradient_set_spread = Tvg_Result function(Tvg_Gradient* grad, const Tvg_Stroke_Fill spread);
        alias ptvg_gradient_get_spread = Tvg_Result function(const Tvg_Gradient* grad, Tvg_Stroke_Fill* spread);
        alias ptvg_gradient_set_transform = Tvg_Result function(Tvg_Gradient* grad, const Tvg_Matrix* m);
        alias ptvg_gradient_get_transform = Tvg_Result function(const Tvg_Gradient* grad, Tvg_Matrix* m);
        static if (tvgSupport >= TVGSupport.v0_9)
        {
            alias ptvg_gradient_get_identifier = Tvg_Result function(const Tvg_Gradient* grad, Tvg_Identifier* identifier);
        }
        alias ptvg_gradient_duplicate = Tvg_Gradient* function(Tvg_Gradient* grad);
        alias ptvg_gradient_del = Tvg_Result function(Tvg_Gradient* grad);
        //************************************************************************/
        //* Picture API                                                          */
        //************************************************************************/
        alias ptvg_picture_new = Tvg_Paint* function();
        alias ptvg_picture_load = Tvg_Result function(Tvg_Paint* paint, const char* path);
        alias ptvg_picture_load_raw = Tvg_Result function(Tvg_Paint* paint, uint *data, uint w, uint h, bool copy);
        alias ptvg_picture_load_data = Tvg_Result function(Tvg_Paint* paint, const char *data, uint size, const char *mimetype, bool copy);
        alias ptvg_picture_set_size = Tvg_Result function(Tvg_Paint* paint, float w, float h);
        alias ptvg_picture_get_size = Tvg_Result function(const Tvg_Paint* paint, float* w, float* h);
        static if (tvgSupport < TVGSupport.v0_10)
        {
            alias ptvg_picture_get_viewbox = Tvg_Result function(const Tvg_Paint* paint, float* x, float* y, float* w, float* h);
        }

        alias ptvg_scene_new = Tvg_Paint* function();
        alias ptvg_scene_reserve = Tvg_Result function(Tvg_Paint* scene, uint size);
        alias ptvg_scene_push = Tvg_Result function(Tvg_Paint* scene, Tvg_Paint* paint);
        alias ptvg_scene_clear = Tvg_Result function(Tvg_Paint* scene, bool free);
        //************************************************************************/
        //* Saver API                                                            */
        //************************************************************************/
        alias ptvg_saver_new = Tvg_Saver* function();
        alias ptvg_saver_save = Tvg_Result function(Tvg_Saver* saver, Tvg_Paint* paint, const char* path, bool compress);
        alias ptvg_saver_sync = Tvg_Result function(Tvg_Saver* saver);
        alias ptvg_saver_del = Tvg_Result function(Tvg_Saver* saver);
    }

    __gshared
    {
        ptvg_engine_init tvg_engine_init;
        ptvg_engine_term tvg_engine_term;
        ptvg_swcanvas_create tvg_swcanvas_create;
        ptvg_swcanvas_set_target tvg_swcanvas_set_target;
        ptvg_swcanvas_set_mempool tvg_swcanvas_set_mempool;
        ptvg_canvas_destroy tvg_canvas_destroy;
        ptvg_canvas_push tvg_canvas_push;
        ptvg_canvas_reserve tvg_canvas_reserve;
        ptvg_canvas_clear tvg_canvas_clear;
        ptvg_canvas_update tvg_canvas_update;
        ptvg_canvas_update_paint tvg_canvas_update_paint;
        ptvg_canvas_draw tvg_canvas_draw;
        ptvg_canvas_sync tvg_canvas_sync;
        ptvg_paint_del tvg_paint_del;
        ptvg_paint_scale tvg_paint_scale;
        ptvg_paint_rotate tvg_paint_rotate;
        ptvg_paint_translate tvg_paint_translate;
        ptvg_paint_set_transform tvg_paint_set_transform;
        ptvg_paint_get_transform tvg_paint_get_transform;
        static if (tvgSupport >= TVGSupport.v0_9)
        {
            ptvg_paint_get_identifier tvg_paint_get_identifier;
        }
        ptvg_paint_set_opacity tvg_paint_set_opacity;
        ptvg_paint_get_opacity tvg_paint_get_opacity;
        ptvg_paint_duplicate tvg_paint_duplicate;
        ptvg_paint_get_bounds tvg_paint_get_bounds;
        ptvg_paint_set_composite_method tvg_paint_set_composite_method;
        ptvg_paint_get_composite_method tvg_paint_get_composite_method;
        ptvg_shape_new tvg_shape_new;
        ptvg_shape_reset tvg_shape_reset;
        ptvg_shape_move_to tvg_shape_move_to;
        ptvg_shape_line_to tvg_shape_line_to;
        ptvg_shape_cubic_to tvg_shape_cubic_to;
        ptvg_shape_close tvg_shape_close;
        ptvg_shape_append_rect tvg_shape_append_rect;
        ptvg_shape_append_circle tvg_shape_append_circle;
        ptvg_shape_append_arc tvg_shape_append_arc;
        ptvg_shape_append_path tvg_shape_append_path;
        ptvg_shape_get_path_coords tvg_shape_get_path_coords;
        ptvg_shape_get_path_commands tvg_shape_get_path_commands;
        ptvg_shape_set_stroke_width tvg_shape_set_stroke_width;
        ptvg_shape_get_stroke_width tvg_shape_get_stroke_width;
        ptvg_shape_set_stroke_color tvg_shape_set_stroke_color;
        ptvg_shape_get_stroke_color tvg_shape_get_stroke_color;
        ptvg_shape_set_stroke_linear_gradient tvg_shape_set_stroke_linear_gradient;
        ptvg_shape_set_stroke_radial_gradient tvg_shape_set_stroke_radial_gradient;
        ptvg_shape_get_stroke_gradient tvg_shape_get_stroke_gradient;
        ptvg_shape_set_stroke_dash tvg_shape_set_stroke_dash;
        ptvg_shape_get_stroke_dash tvg_shape_get_stroke_dash;
        ptvg_shape_set_stroke_cap tvg_shape_set_stroke_cap;
        ptvg_shape_get_stroke_cap tvg_shape_get_stroke_cap;
        ptvg_shape_set_stroke_join tvg_shape_set_stroke_join;
        ptvg_shape_get_stroke_join tvg_shape_get_stroke_join;
        ptvg_shape_set_fill_color tvg_shape_set_fill_color;
        ptvg_shape_get_fill_color tvg_shape_get_fill_color;
        ptvg_shape_set_fill_rule tvg_shape_set_fill_rule;
        ptvg_shape_get_fill_rule tvg_shape_get_fill_rule;
        ptvg_shape_set_linear_gradient tvg_shape_set_linear_gradient;
        ptvg_shape_set_radial_gradient tvg_shape_set_radial_gradient;
        ptvg_shape_get_gradient tvg_shape_get_gradient;
        ptvg_linear_gradient_new tvg_linear_gradient_new;
        ptvg_radial_gradient_new tvg_radial_gradient_new;
        ptvg_linear_gradient_set tvg_linear_gradient_set;
        ptvg_linear_gradient_get tvg_linear_gradient_get;
        ptvg_radial_gradient_set tvg_radial_gradient_set;
        ptvg_radial_gradient_get tvg_radial_gradient_get;
        ptvg_gradient_set_color_stops tvg_gradient_set_color_stops;
        ptvg_gradient_get_color_stops tvg_gradient_get_color_stops;
        ptvg_gradient_set_spread tvg_gradient_set_spread;
        ptvg_gradient_get_spread tvg_gradient_get_spread;
        ptvg_gradient_set_transform tvg_gradient_set_transform;
        ptvg_gradient_get_transform tvg_gradient_get_transform;
        static if (tvgSupport >= TVGSupport.v0_9)
        {
            ptvg_gradient_get_identifier tvg_gradient_get_identifier;
        }
        ptvg_gradient_duplicate tvg_gradient_duplicate;
        ptvg_gradient_del tvg_gradient_del;
        ptvg_picture_new tvg_picture_new;
        ptvg_picture_load tvg_picture_load;
        ptvg_picture_load_raw tvg_picture_load_raw;
        ptvg_picture_load_data tvg_picture_load_data;
        ptvg_picture_set_size tvg_picture_set_size;
        ptvg_picture_get_size tvg_picture_get_size;
        ptvg_picture_get_viewbox tvg_picture_get_viewbox;
        ptvg_scene_new tvg_scene_new;
        ptvg_scene_reserve tvg_scene_reserve;
        ptvg_scene_push tvg_scene_push;
        ptvg_scene_clear tvg_scene_clear;
        ptvg_saver_new tvg_saver_new;
        ptvg_saver_save tvg_saver_save;
        ptvg_saver_sync tvg_saver_sync;
        ptvg_saver_del tvg_saver_del;
    }
}

