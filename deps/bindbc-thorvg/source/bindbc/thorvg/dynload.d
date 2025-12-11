module bindbc.thorvg.dynload;

version (BindTVG_Static) {}
else:

import bindbc.loader;
import bindbc.thorvg.config,
       bindbc.thorvg.bind;

private
{
    SharedLib lib;
    TVGSupport loadedVersion;
}

@nogc nothrow:
void unloadThorVG()
{
    if (lib != invalidHandle)
    {
        lib.unload();
    }
}

TVGSupport loadedThorVGVersion()
{
    return loadedThorVGVersion;
}

bool isThorVGLoaded()
{
    return lib != invalidHandle;
}

TVGSupport loadThorVG()
{
    // See https://github.com/BindBC/bindbc-loader/blob/master/source/bindbc/loader/codegen.d
    enum libNamesCT = mixin(makeLibPaths(["thorvg"]));

    string[libNamesCT.length] libNames = libNamesCT;

    TVGSupport ret;
    foreach (name; libNames)
    {
        ret = loadThorVG(name.ptr);
        if (ret != TVGSupport.noLibrary)
        {
            break;
        }
    }
    return ret;
}

TVGSupport loadThorVG(const(char)* libName)
{
    lib = load(libName);
    if (lib == invalidHandle)
    {
        return TVGSupport.noLibrary;
    }

    auto errCount = errorCount();

    lib.bindSymbol(cast(void**)&tvg_engine_init, "tvg_engine_init");
    lib.bindSymbol(cast(void**)&tvg_engine_term, "tvg_engine_term");
    lib.bindSymbol(cast(void**)&tvg_swcanvas_create, "tvg_swcanvas_create");
    lib.bindSymbol(cast(void**)&tvg_swcanvas_set_target, "tvg_swcanvas_set_target");
    lib.bindSymbol(cast(void**)&tvg_swcanvas_set_mempool, "tvg_swcanvas_set_mempool");
    lib.bindSymbol(cast(void**)&tvg_canvas_destroy, "tvg_canvas_destroy");
    lib.bindSymbol(cast(void**)&tvg_canvas_push, "tvg_canvas_push");
    lib.bindSymbol(cast(void**)&tvg_canvas_reserve, "tvg_canvas_reserve");
    lib.bindSymbol(cast(void**)&tvg_canvas_clear, "tvg_canvas_clear");
    lib.bindSymbol(cast(void**)&tvg_canvas_update, "tvg_canvas_update");
    lib.bindSymbol(cast(void**)&tvg_canvas_update_paint, "tvg_canvas_update_paint");
    lib.bindSymbol(cast(void**)&tvg_canvas_draw, "tvg_canvas_draw");
    lib.bindSymbol(cast(void**)&tvg_canvas_sync, "tvg_canvas_sync");
    lib.bindSymbol(cast(void**)&tvg_paint_del, "tvg_paint_del");
    lib.bindSymbol(cast(void**)&tvg_paint_scale, "tvg_paint_scale");
    lib.bindSymbol(cast(void**)&tvg_paint_rotate, "tvg_paint_rotate");
    lib.bindSymbol(cast(void**)&tvg_paint_translate, "tvg_paint_translate");
    lib.bindSymbol(cast(void**)&tvg_paint_set_transform, "tvg_paint_set_transform");
    lib.bindSymbol(cast(void**)&tvg_paint_get_transform, "tvg_paint_get_transform");
    lib.bindSymbol(cast(void**)&tvg_paint_set_opacity, "tvg_paint_set_opacity");
    lib.bindSymbol(cast(void**)&tvg_paint_get_opacity, "tvg_paint_get_opacity");
    lib.bindSymbol(cast(void**)&tvg_paint_duplicate, "tvg_paint_duplicate");
    lib.bindSymbol(cast(void**)&tvg_paint_get_bounds, "tvg_paint_get_bounds");
    lib.bindSymbol(cast(void**)&tvg_paint_set_composite_method, "tvg_paint_set_composite_method");
    lib.bindSymbol(cast(void**)&tvg_paint_get_composite_method, "tvg_paint_get_composite_method");
    lib.bindSymbol(cast(void**)&tvg_shape_new, "tvg_shape_new");
    lib.bindSymbol(cast(void**)&tvg_shape_reset, "tvg_shape_reset");
    lib.bindSymbol(cast(void**)&tvg_shape_move_to, "tvg_shape_move_to");
    lib.bindSymbol(cast(void**)&tvg_shape_line_to, "tvg_shape_line_to");
    lib.bindSymbol(cast(void**)&tvg_shape_cubic_to, "tvg_shape_cubic_to");
    lib.bindSymbol(cast(void**)&tvg_shape_close, "tvg_shape_close");
    lib.bindSymbol(cast(void**)&tvg_shape_append_rect, "tvg_shape_append_rect");
    lib.bindSymbol(cast(void**)&tvg_shape_append_circle, "tvg_shape_append_circle");
    lib.bindSymbol(cast(void**)&tvg_shape_append_arc, "tvg_shape_append_arc");
    lib.bindSymbol(cast(void**)&tvg_shape_append_path, "tvg_shape_append_path");
    lib.bindSymbol(cast(void**)&tvg_shape_get_path_coords, "tvg_shape_get_path_coords");
    lib.bindSymbol(cast(void**)&tvg_shape_get_path_commands, "tvg_shape_get_path_commands");
    lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_width, "tvg_shape_set_stroke_width");
    lib.bindSymbol(cast(void**)&tvg_shape_get_stroke_width, "tvg_shape_get_stroke_width");
    lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_color, "tvg_shape_set_stroke_color");
    lib.bindSymbol(cast(void**)&tvg_shape_get_stroke_color, "tvg_shape_get_stroke_color");
    lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_linear_gradient, "tvg_shape_set_stroke_linear_gradient");
    lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_radial_gradient, "tvg_shape_set_stroke_radial_gradient");
    lib.bindSymbol(cast(void**)&tvg_shape_get_stroke_gradient, "tvg_shape_get_stroke_gradient");
    lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_dash, "tvg_shape_set_stroke_dash");
    lib.bindSymbol(cast(void**)&tvg_shape_get_stroke_dash, "tvg_shape_get_stroke_dash");
    lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_cap, "tvg_shape_set_stroke_cap");
    lib.bindSymbol(cast(void**)&tvg_shape_get_stroke_cap, "tvg_shape_get_stroke_cap");
    lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_join, "tvg_shape_set_stroke_join");
    lib.bindSymbol(cast(void**)&tvg_shape_get_stroke_join, "tvg_shape_get_stroke_join");
    lib.bindSymbol(cast(void**)&tvg_shape_set_fill_color, "tvg_shape_set_fill_color");
    lib.bindSymbol(cast(void**)&tvg_shape_get_fill_color, "tvg_shape_get_fill_color");
    lib.bindSymbol(cast(void**)&tvg_shape_set_fill_rule, "tvg_shape_set_fill_rule");
    lib.bindSymbol(cast(void**)&tvg_shape_get_fill_rule, "tvg_shape_get_fill_rule");
    lib.bindSymbol(cast(void**)&tvg_shape_set_linear_gradient, "tvg_shape_set_linear_gradient");
    lib.bindSymbol(cast(void**)&tvg_shape_set_radial_gradient, "tvg_shape_set_radial_gradient");
    lib.bindSymbol(cast(void**)&tvg_shape_get_gradient, "tvg_shape_get_gradient");
    lib.bindSymbol(cast(void**)&tvg_linear_gradient_new, "tvg_linear_gradient_new");
    lib.bindSymbol(cast(void**)&tvg_radial_gradient_new, "tvg_radial_gradient_new");
    lib.bindSymbol(cast(void**)&tvg_linear_gradient_set, "tvg_linear_gradient_set");
    lib.bindSymbol(cast(void**)&tvg_linear_gradient_get, "tvg_linear_gradient_get");
    lib.bindSymbol(cast(void**)&tvg_radial_gradient_set, "tvg_radial_gradient_set");
    lib.bindSymbol(cast(void**)&tvg_radial_gradient_get, "tvg_radial_gradient_get");
    lib.bindSymbol(cast(void**)&tvg_gradient_set_color_stops, "tvg_gradient_set_color_stops");
    lib.bindSymbol(cast(void**)&tvg_gradient_get_color_stops, "tvg_gradient_get_color_stops");
    lib.bindSymbol(cast(void**)&tvg_gradient_set_spread, "tvg_gradient_set_spread");
    lib.bindSymbol(cast(void**)&tvg_gradient_get_spread, "tvg_gradient_get_spread");
    lib.bindSymbol(cast(void**)&tvg_gradient_set_transform, "tvg_gradient_set_transform");
    lib.bindSymbol(cast(void**)&tvg_gradient_get_transform, "tvg_gradient_get_transform");
    lib.bindSymbol(cast(void**)&tvg_gradient_duplicate, "tvg_gradient_duplicate");
    lib.bindSymbol(cast(void**)&tvg_gradient_del, "tvg_gradient_del");
    lib.bindSymbol(cast(void**)&tvg_picture_new, "tvg_picture_new");
    lib.bindSymbol(cast(void**)&tvg_picture_load, "tvg_picture_load");
    lib.bindSymbol(cast(void**)&tvg_picture_load_raw, "tvg_picture_load_raw");
    lib.bindSymbol(cast(void**)&tvg_picture_load_data, "tvg_picture_load_data");
    lib.bindSymbol(cast(void**)&tvg_picture_set_size, "tvg_picture_set_size");
    lib.bindSymbol(cast(void**)&tvg_picture_get_size, "tvg_picture_get_size");
    lib.bindSymbol(cast(void**)&tvg_scene_new, "tvg_scene_new");
    lib.bindSymbol(cast(void**)&tvg_scene_reserve, "tvg_scene_reserve");
    lib.bindSymbol(cast(void**)&tvg_scene_push, "tvg_scene_push");
    lib.bindSymbol(cast(void**)&tvg_scene_clear, "tvg_scene_clear");
    lib.bindSymbol(cast(void**)&tvg_saver_new, "tvg_saver_new");
    lib.bindSymbol(cast(void**)&tvg_saver_save, "tvg_saver_save");
    lib.bindSymbol(cast(void**)&tvg_saver_sync, "tvg_saver_sync");
    lib.bindSymbol(cast(void**)&tvg_saver_del, "tvg_saver_del");

    static if (tvgSupport < TVGSupport.v0_10)
    {
        lib.bindSymbol(cast(void**)&tvg_picture_get_viewbox, "tvg_picture_get_viewbox");
    }

    if (errorCount() != errCount) return TVGSupport.badLibrary;
    else loadedVersion = TVGSupport.v0_8;

    static if (tvgSupport >= TVGSupport.v0_9)
    {
        lib.bindSymbol(cast(void**)&tvg_paint_get_identifier, "tvg_paint_get_identifier");
        lib.bindSymbol(cast(void**)&tvg_gradient_get_identifier, "tvg_gradient_get_identifier");

        if (errorCount() != errCount) return TVGSupport.badLibrary;
        else loadedVersion = TVGSupport.v0_9;
    }

    static if (tvgSupport >= TVGSupport.v0_10)
    {
        lib.bindSymbol(cast(void**)&tvg_shape_set_stroke_miterlimit, "tvg_shape_set_stroke_miterlimit");
        lib.bindSymbol(cast(void**)&tvg_shape_get_stroke_miterlimit, "tvg_shape_get_stroke_miterlimit");
        lib.bindSymbol(cast(void**)&tvg_shape_set_paint_order, "tvg_shape_set_paint_order");

        if (errorCount() != errCount) return TVGSupport.badLibrary;
        else loadedVersion = TVGSupport.v0_10;
    }

    return loadedVersion;
}

