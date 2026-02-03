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
        return Childs_range (this.cl);
    }

    auto
    childs_recursive () {
        return childs_recursive_range (this,this);
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
        E    front;
        bool empty    () { return front is null; }
        void popFront () { front = front.r; }
    }

    struct
    childs_recursive_range {
        E    front;
        E    start;
        bool empty    () { return front is null; }
        void popFront () {
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
                e = e.parent;
                if (e !is start)
                    goto go_right;
            }
            // end
            front = null;
        }
    }

}

