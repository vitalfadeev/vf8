module vf.gui.layout;

version (GUI):
import vf.std.xywh     : Xy,Wh,Xywh;
import vf.gui.widget   : Widget;
import std.stdio : writeln;


union
Layout {
union {
    Type                    type;
    Grid_layout             grid;
    Quick_settings_layout   quick_settings;
}
    auto range ()       { return grid.range (); }
    auto select (Xy xy) { return grid.select (xy); }

    enum 
    Type {
        _,
        GRID,
        QUICK_SETTINGS,
    }
}

struct
Line_layout {    
    void
    layout (Widget widget) {
        Xy xy = widget.xywh.xy;

        foreach (_widget; widget.childs.norecursive) {
            _widget.xywh.xy = xy;

            xy.x += _widget.xywh.w;
        }
    }
}

struct
Column_layout {    
    void
    layout (Widget widget) {
        int w;
        int h;
        Xy  xy = widget.xywh.xy;

        foreach (_widget; widget.childs.norecursive) {
            _widget.xywh.xy = xy;

            xy.y += _widget.xywh.h;
        }
    }
}

struct
Lcr_layout {    
    int w;
    int h;

    void
    layout (Widget widget) {
        Xy xy = widget.xywh.xy;
        Wh wh = widget.xywh.wh;

        foreach (i,_widget; widget.childs.norecursive) {
            switch (i) {
                case 0: _widget.xywh.xy.x = xy.x; break;
                case 1: _widget.xywh.xy.x = xy.x + (wh.w - (cast (uint) _widget.childs.length) * w) / 2; break;
                case 2: _widget.xywh.xy.x = xy.x + (wh.w - (cast (uint) _widget.childs.length) * w); break;
                default:
            }
        }
    }
}

struct
Lr_layout {
    int w;
    int h;

    void
    layout (Widget widget) {
        Xy xy = widget.xywh.xy;
        Wh wh = widget.xywh.wh;

        foreach (i,_widget; widget.childs.norecursive) {
            switch (i) {
                case 0: _widget.xywh.xy.x = xy.x; break;
                case 1: _widget.xywh.xy.x = xy.x + (wh.w - (cast (uint) _widget.childs.length) * w); break;
                default:
            }
        }
    }
}

struct
Grid_layout_ {    
    ubyte size_x;
    ubyte size_y;

    void
    layout (Widget widget) {
        Xy xy = widget.xywh.xy;

        foreach (i,_widget; widget.childs.norecursive) {
            _widget.xywh.xy = xy;

            if ((i+1) % size_x != 0) {          // row
                xy.x += _widget.xywh.w;
            } 
            else {                          // new row
                xy.x  = widget.xywh.xy.x;
                xy.y += _widget.xywh.h;;
            }
        }
    }
}

struct
Grid_layout {
    Layout.Type type;
    // total
    Wh     total_wh;
    // xy
    ushort cells_on_x;
    ushort cells_on_y;
    ushort cells_offset_x;
    ushort cells_offset_y;
    ushort cells_space_x;
    ushort cells_space_y;
    // wh
    ushort cells_w;
    ushort cells_h;
    ushort first_cell_w;
    ushort first_cell_h;
    ushort last_cell_w;
    ushort last_cell_h;
    //
    Order_rec[5] order;  // 10 Bytes
    // center
    //   dup Range
    //     calc total_wh      // for left,right,center,both (10,01,00,11)
    //     calc translate_xy
    //   dup Range
    //     translate (xy)

    // Layout args
    //   3 left, 1 center, 5 right
    //
    //   _1st_left_w  = 2x
    //   _Lst_right_w = 2x
    //   _center_w    = 2x
    //
    // left...  ...center... ... right
    // 1        2    3   4           5   // 5 loca
    // vars
    // loca_1 3  // 3 e
    // loca_2 2  // 2 e
    // loca_3 1  // 1 e
    // loca_4 2  // 2 e
    // loca_5 3  // 3 e
    //
    // e eee ee ee eee - flow  [11]
    // 3 111 22 44 555 - order [11]
    //
    // . . . . .
    // 3 1 2 4 5 - loca               // 5 Bytes  // 16 bit
    // 1 3 2 2 3 - n     // 0xFF max  // 5 Bytes  // 

    struct 
    Order_rec {
        Loca loca;
        N    n;
    }

    alias Loca = ubyte;
    alias N    = ubyte;

    Range
    range () {
        return Range (&this);  // return Xywh,Xywh,...
    }

    auto
    select (Xy xy) {
        return filter (range,xy);
    }

    auto
    filter (R) (R range, Xy xy) {
        return Filter!R (range,xy);
    }

    struct
    Filter (R) {
        R      range;
        Xy     xy;
        ubyte  i;
        import std.typecons;
        alias  Result = Tuple!(ubyte,Xywh);
        Result front () { return tuple (i,range.front); }
        bool   empty () { while (!range.empty && !range.front.has (xy)) this.popFront (); return range.empty; }
        void   popFront () { range.popFront; i++; }

        this (R range, Xy xy) {
            this.range = range;
            this.xy = xy;
        }
    }

    struct
    Range {
        Grid_layout* _layout;
        typeof (_layout.order[]) order;
        Loca loca;
        N    n;

        Xywh front;
        bool empty () { return n == 0; }
        void popFront () { 
            import std.range;
            n--; 
            if (n == 0) {
                order.popFront ();
                if (order.empty) {
                    n = 0;
                    return; // END
                }
                else {
                    // next rec
                    n    = order.front.n;
                    loca = order.front.loca;
                    // reset xywh
                    reset ();
                }
            }
            else {                
                // update front
                step ();  
            }
        }

        this (Grid_layout* _layout) {
            import std.range;
            this._layout = _layout;
            order = _layout.order[];
            loca  = order.front.loca;
            n     = order.front.n;
            reset ();
        }

        void 
        reset () {
            switch (loca) {
                case 1:  // left, to right
                    front.x = _layout.cells_offset_x;
                    break;
                case 2:  // center, to left
                    front.x = _layout.cells_offset_x + _layout.total_wh.w / 2 - _layout.cells_w / 2 - _layout.cells_w;
                    break;
                case 3:  // center
                    front.x = _layout.cells_offset_x + _layout.total_wh.w / 2 - _layout.cells_w / 2;
                    break;
                case 4:  // center, to right
                    front.x = _layout.cells_offset_x + _layout.total_wh.w / 2 + _layout.cells_w / 2;
                    break;
                case 5:  // right, to left
                    front.x = _layout.total_wh.w - _layout.cells_w;
                    break;
                default:
                    front.x = _layout.cells_offset_x;
            }

            front.y = _layout.cells_offset_y;
            front.w = _layout.first_cell_w;
            front.h = _layout.first_cell_h;            
        }

        void
        step () {
            // step
            switch (loca) {
                case 1:  // left, to right
                    front.x += _layout.cells_w + _layout.cells_space_x;
                    break;
                case 2:  // center, to left
                    front.x -= _layout.cells_w + _layout.cells_space_x;
                    break;
                case 3:  // center
                    //front.x += _layout.cells_w + _layout.cells_space_x;
                    break;
                case 4:  // center, to right
                    front.x += _layout.cells_w + _layout.cells_space_x;
                    break;
                case 5:  // right, to left
                    front.x -= _layout.cells_w + _layout.cells_space_x;
                    break;
                default:
            }
        }
    }
}

// QUICK_SETTINGS
// 1   2 2 2
// 3 -------
// 3 -------
// 4--- ---4
// 4--- ---4
// 4--- ---4
struct
Quick_settings_layout {
    Layout.Type type;
    // total
    Wh     total_wh;
    // xy
    ushort cells1_on_x;
    ushort cells1_on_y;
    ushort cells1_offset_x;
    ushort cells1_offset_y;
    ushort cells1_space_x;
    ushort cells1_space_y;
    //
    ushort cells2_on_x;
    ushort cells2_on_y;
    ushort cells2_offset_x;
    ushort cells2_offset_y;
    ushort cells2_space_x;
    ushort cells2_space_y;
    //
    ushort cells3_on_x;
    ushort cells3_on_y;
    ushort cells3_offset_x;
    ushort cells3_offset_y;
    ushort cells3_space_x;
    ushort cells3_space_y;
    //
    ushort cells4_on_x;
    ushort cells4_on_y;
    ushort cells4_offset_x;
    ushort cells4_offset_y;
    ushort cells4_space_x;
    ushort cells4_space_y;
    // wh
    ushort cells1_w;
    ushort cells1_h;
    //
    ushort cells2_w;
    ushort cells2_h;
    //
    ushort cells3_w;
    ushort cells3_h;
    //
    ushort cells4_w;
    ushort cells4_h;
    //
    Order_rec[4] order;  // 8 Bytes  // [1:1, 2:3, 3:2, 4:6]

    struct 
    Order_rec {
        Loca loca;
        N    n;
    }

    alias Loca = ubyte;
    alias N    = ubyte;

    Range
    range () {
        return Range (&this);  // return Xywh,Xywh,...
    }

    struct
    Range {
        Quick_settings_layout* _layout;
        typeof (_layout.order[]) order;
        Loca loca;
        N    n;
        N    i;

        Xywh front;
        bool empty () { return n == 0; }
        void popFront () { 
            import std.range;
            n--; 
            if (n == 0) {
                order.popFront ();
                if (order.empty) {
                    n = 0;
                    return; // END
                }
                else {
                    // next rec
                    n    = order.front.n;
                    loca = order.front.loca;
                    // reset xywh
                    reset ();
                }
            }
            else {                
                // update front
                step ();  
            }
        }

        this (Quick_settings_layout* _layout) {
            import std.range;
            this._layout = _layout;
            order = _layout.order[];
            loca  = order.front.loca;
            n     = order.front.n;
            i     = 0;
            reset ();
        }

        void 
        reset () {
            switch (loca) {
                case 1:  // left, to right
                    front.x = _layout.cells1_offset_x;
                    front.y = _layout.cells1_offset_y;
                    front.w = _layout.cells1_w;
                    front.h = _layout.cells1_h;
                    break;
                case 2:  // right, to left
                    front.x = _layout.total_wh.w - _layout.cells2_w;
                    front.y = _layout.cells2_offset_y;
                    front.w = _layout.cells2_w;
                    front.h = _layout.cells2_h;
                    break;
                case 3:  // line down 
                    front.x = _layout.cells3_offset_x;
                    front.y = _layout.cells3_offset_y;
                    front.w = _layout.cells3_w;
                    front.h = _layout.cells3_h;
                    break;
                case 4:  // left 1/2 w, to right
                    front.x = _layout.cells4_offset_x;
                    front.y = _layout.cells4_offset_y;
                    front.w = _layout.cells4_w;
                    front.h = _layout.cells4_h;            
                    break;
                default:
            }
            i = 0;
        }

        void
        step () {
            // step
            switch (loca) {
                case 1:  // left, to right
                    front.x += _layout.cells1_w + _layout.cells1_space_x;
                    break;
                case 2:  // right, to left
                    front.x -= _layout.cells2_w + _layout.cells2_space_x;
                    break;
                case 3:  // line down
                    front.y += _layout.cells3_h + _layout.cells3_space_y;
                    break;
                case 4:  // left 1/2 w, to right
                    // 1
                    if (i % 2 == 0) {                        
                        front.x += _layout.cells4_w + _layout.cells4_space_x;
                    }
                    // 2
                    else { 
                        front.x  = _layout.cells4_w;
                        front.y += _layout.cells4_h + _layout.cells4_space_y;
                    }
                    break;
                default:
            }
            i++;
        }
    }
}
