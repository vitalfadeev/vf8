module bindbc.thorvg.bind.types;

import bindbc.thorvg.config;

struct Tvg_Canvas;
struct Tvg_Paint;
struct Tvg_Gradient;
struct Tvg_Saver;
enum Tvg_Engine
{
    TVG_ENGINE_SW = (1 << 1),   ///< CPU rasterizer.
    TVG_ENGINE_GL = (1 << 2)    ///< OpenGL rasterizer.
}
enum Tvg_Result
{
    TVG_RESULT_SUCCESS = 0,            ///< The value returned in case of a correct request execution.
    TVG_RESULT_INVALID_ARGUMENT,       ///< The value returned in the event of a problem with the arguments given to the API - e.g. empty paths or null pointers.
    TVG_RESULT_INSUFFICIENT_CONDITION, ///< The value returned in case the request cannot be processed - e.g. asking for properties of an object, which does not exist.
    TVG_RESULT_FAILED_ALLOCATION,      ///< The value returned in case of unsuccessful memory allocation.
    TVG_RESULT_MEMORY_CORRUPTION,      ///< The value returned in the event of bad memory handling - e.g. failing in pointer releasing or casting
    TVG_RESULT_NOT_SUPPORTED,          ///< The value returned in case of choosing unsupported options.
    TVG_RESULT_UNKNOWN                 ///< The value returned in all other cases.
}
static if (tvgSupport < TVGSupport.v0_9)
{
    enum Tvg_Composite_Method
    {
        TVG_COMPOSITE_METHOD_NONE = 0,           ///< No composition is applied.
        TVG_COMPOSITE_METHOD_CLIP_PATH,          ///< The intersection of the source and the target is determined and only the resulting pixels from the source are rendered.
        TVG_COMPOSITE_METHOD_ALPHA_MASK,         ///< The pixels of the source and the target are alpha blended. As a result, only the part of the source, which intersects with the target is visible.
        TVG_COMPOSITE_METHOD_INVERSE_ALPHA_MASK  ///< The pixels of the source and the complement to the target's pixels are alpha blended. As a result, only the part of the source which is not covered by the target is visible.
    }
}
else
{
    enum Tvg_Composite_Method
    {
        TVG_COMPOSITE_METHOD_NONE = 0,           ///< No composition is applied.
        TVG_COMPOSITE_METHOD_CLIP_PATH,          ///< The intersection of the source and the target is determined and only the resulting pixels from the source are rendered.
        TVG_COMPOSITE_METHOD_ALPHA_MASK,         ///< The pixels of the source and the target are alpha blended. As a result, only the part of the source, which intersects with the target is visible.
        TVG_COMPOSITE_METHOD_INVERSE_ALPHA_MASK, ///< The pixels of the source and the complement to the target's pixels are alpha blended. As a result, only the part of the source which is not covered by the target is visible.
        TVG_COMPOSITE_METHOD_LUMA_MASK           ///< The source pixels are converted to grayscale (luma value) and alpha blended with the target. As a result, only the part of the source which intersects with the target is visible. \since 0.9
    }
}
static if (tvgSupport >= TVGSupport.v0_9)
{
    enum Tvg_Identifier
    {
        TVG_IDENTIFIER_UNDEF = 0,   ///< Undefined type.
        TVG_IDENTIFIER_SHAPE,       ///< A shape type paint.
        TVG_IDENTIFIER_SCENE,       ///< A scene type paint.
        TVG_IDENTIFIER_PICTURE,     ///< A picture type paint.
        TVG_IDENTIFIER_LINEAR_GRAD, ///< A linear gradient type.
        TVG_IDENTIFIER_RADIAL_GRAD  ///< A radial gradient type.
    }
}
enum Tvg_Path_Command
{
    TVG_PATH_COMMAND_CLOSE = 0, ///< Ends the current sub-path and connects it with its initial point - corresponds to Z command in the svg path commands.
    TVG_PATH_COMMAND_MOVE_TO,   ///< Sets a new initial point of the sub-path and a new current point - corresponds to M command in the svg path commands.
    TVG_PATH_COMMAND_LINE_TO,   ///< Draws a line from the current point to the given point and sets a new value of the current point - corresponds to L command in the svg path commands.
    TVG_PATH_COMMAND_CUBIC_TO   ///< Draws a cubic Bezier curve from the current point to the given point using two given control points and sets a new value of the current point - corresponds to C command in the svg path commands.
}
enum Tvg_Stroke_Cap
{
    TVG_STROKE_CAP_SQUARE = 0, ///< The stroke is extended in both endpoints of a sub-path by a rectangle, with the width equal to the stroke width and the length equal to the half of the stroke width. For zero length sub-paths the square is rendered with the size of the stroke width.
    TVG_STROKE_CAP_ROUND,      ///< The stroke is extended in both endpoints of a sub-path by a half circle, with a radius equal to the half of a stroke width. For zero length sub-paths a full circle is rendered.
    TVG_STROKE_CAP_BUTT        ///< The stroke ends exactly at each of the two endpoints of a sub-path. For zero length sub-paths no stroke is rendered.
}
enum Tvg_Stroke_Join
{
    TVG_STROKE_JOIN_BEVEL = 0, ///< The outer corner of the joined path segments is bevelled at the join point. The triangular region of the corner is enclosed by a straight line between the outer corners of each stroke.
    TVG_STROKE_JOIN_ROUND,     ///< The outer corner of the joined path segments is rounded. The circular region is centered at the join point.
    TVG_STROKE_JOIN_MITER      ///< The outer corner of the joined path segments is spiked. The spike is created by extension beyond the join point of the outer edges of the stroke until they intersect. In case the extension goes beyond the limit, the join style is converted to the Bevel style.
}
enum Tvg_Stroke_Fill
{
    TVG_STROKE_FILL_PAD = 0, ///< The remaining area is filled with the closest stop color.
    TVG_STROKE_FILL_REFLECT, ///< The gradient pattern is reflected outside the gradient area until the expected region is filled.
    TVG_STROKE_FILL_REPEAT   ///< The gradient pattern is repeated continuously beyond the gradient area until the expected region is filled.
}
enum Tvg_Fill_Rule
{
    TVG_FILL_RULE_WINDING = 0, ///< A line from the point to a location outside the shape is drawn. The intersections of the line with the path segment of the shape are counted. Starting from zero, if the path segment of the shape crosses the line clockwise, one is added, otherwise one is subtracted. If the resulting sum is non zero, the point is inside the shape.
    TVG_FILL_RULE_EVEN_ODD     ///< A line from the point to a location outside the shape is drawn and its intersections with the path segments of the shape are counted. If the number of intersections is an odd number, the point is inside the shape.
}
struct Tvg_Color_Stop
{
    float offset; /**< The relative position of the color. */
    ubyte r;      /**< The red color channel value in the range [0 ~ 255]. */
    ubyte g;      /**< The green color channel value in the range [0 ~ 255]. */
    ubyte b;      /**< The blue color channel value in the range [0 ~ 255]. */
    ubyte a;      /**< The alpha channel value in the range [0 ~ 255], where 0 is completely transparent and 255 is opaque. */
}
struct Tvg_Point
{
    float x, y;
}
struct Tvg_Matrix
{
    float e11, e12, e13;
    float e21, e22, e23;
    float e31, e32, e33;
}

//************************************************************************/
//* SwCanvas API                                                         */
//************************************************************************/
enum Tvg_Mempool_Policy
{
    TVG_MEMPOOL_POLICY_DEFAULT = 0, ///< Default behavior that ThorVG is designed to.
    TVG_MEMPOOL_POLICY_SHAREABLE,   ///< Memory Pool is shared among canvases.
    TVG_MEMPOOL_POLICY_INDIVIDUAL   ///< Allocate designated memory pool that is used only by the current canvas instance.
}
enum Tvg_Colorspace
{
    TVG_COLORSPACE_ABGR8888 = 0, ///< The 8-bit color channels are combined into 32-bit color in the order: alpha, blue, green, red.
    TVG_COLORSPACE_ARGB8888      ///< The 8-bit color channels are combined into 32-bit color in the order: alpha, red, green, blue.
}

