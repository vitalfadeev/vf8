module childs_parent;

mixin template
Childs_parent (E) {
    E l;
    E r;
    E cl;
    E cr;
    E parent;

    auto
    childs () {
        return Childs_range (this);
    }

    auto
    has_childs () {
        return cl !is null;
    }

    E
    add_child  (E c) {
        auto t = this;
        auto tr = t.cr;
        if (tr is null) {
            t.cr = c;
            t.cl = c;
        }
        else {
            c.l = tr;
            tr.r = c;
            t.cr = c;
        }
        c.parent = t;

        return c;
    }

    struct
    Childs_range {
        E _this;

        int 
        opApply (scope int delegate(E) dg) {
            int result = 0;

            for (auto _e = _this.cl; _e !is null; _e = _e.r) {
                result = dg (_e);

                if (result)
                    break;
            }

            return result;
        }
    }
}

