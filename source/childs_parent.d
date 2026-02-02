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

    auto
    childs_recursive () {
        return childs_recursive_range (this);
    }

    struct
    childs_recursive_range {
        E _this;

        E front;
        bool empty () { return front is null; }
        void
        popFront () {
            auto e = front;
            // go down
            go_down:
            if (e.cl !is null) {
                front = e.cl;
                return;
            }
            // go right
            go_right:
            if (e.r !is null) {
                front = e.r;
                return;
            }
            // go up
            if (e.parent !is null) {
                front = e.parent;
                goto go_right;
            }
            // end
            front = null;
        }
    }

}

