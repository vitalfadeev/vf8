module vf.gui;

import vf.e_class      : E;
import importc;


struct
Gui {
    E e;

    void
    open (O) (O o) {
        tvg_engine_init(4);
    }

    //void
    //load_ui (O) (O o) {
    //    //
    //}

    E
    select (int x, int y) {
        return select (e,x,y);
    }

    E
    select (E e, int x, int y) {
        if (e !is null)
        if (_select (e,x,y)) {
            // childs
            foreach (c; e.childs) {
                if (_select (c,x,y)) {
                    auto cc = select (c,x,y);
                    if (cc !is null) return cc;
                    else return c;
                }
            }
        }

        return e;
    }

    bool
    _select (E e, int x, int y) {
        auto _xy = e.xy;
        if (_xy.x <= x && _xy.y < y) {
            auto _wh = e.wh;
            if (x < (_xy.x + _wh.w) && y < (_xy.y + _wh.h)) {
                return true;
            }
        }

        return false;
    }
}
