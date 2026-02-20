module vf.gui.page;

version (GUI):
version (E_32BIT_PAGED):

import vf.std.tstring256;
import vf.gui.colors   : Color;
import vf.gui.layout   : Layout;
import vf.std.xywh     : XY,WH,XYWH;
import vf.gui.e        : E;


struct
Page {
    Tstring256!E es;
    WH           wh;         // ushort x ushort  16368 x 16368
    Layout       layout;  // grid, ...
}
