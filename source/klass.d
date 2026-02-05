module klass;

import e_class;
import attrs;
import event;
import app : O=O3;


class
Klass {
    string name;
    void*  data1;
    mixin  Attrs;

    this (string name) {
        this.name = name;
    }

    void 
    go (Event* evt) {
        //
    }

    override
    string
    toString () {
        return name;
    }

    mixin template
    tpl () {
        Klass[] _klasses;

        auto
        klasses () {
            alias T = typeof(this);
            return Klasses_range!T (this);
        }

        auto
        add_klass (Klass k) {
            if (!has_klass (k))
            if (k !is null)
                _klasses ~= k;
            return this;
        }

        auto
        has_klass (string name) {
            foreach (k; _klasses) {
                if (k.name == name)
                    return k;
            }
            return null;
        }

        auto
        has_klass (Klass k) {
            foreach (_k; _klasses) {
                if (_k == k)
                    return k;
            }
            return null;
        }

        void
        rem_klass (Klass k) {
            _klasses = _klasses.remove_element (k);
        }

        void
        set_e_prop (Klass k) {
            foreach (key,value; k.attrs) {
                if (value.type)
                    this.attrs[key] = value;
            }
        }

        struct
        Klasses_range (T) {
            T _this;

            int 
            opApply (scope int delegate(Klass k) dg) {
                int result = 0;

                foreach (k; _this._klasses) {
                    result = dg (k);

                    if (result)
                        break;
                }

                return result;
            }
        }    
    }
}

auto 
remove_element (R, N) (ref R haystack, N needle) {
    import std.algorithm : countUntil, remove;
    auto index = haystack.countUntil (needle);
    return (index != -1) ? haystack.remove (index) : haystack;
}


struct
Event_attrs {
    mixin Attrs;
}

void
window_ (Event* evt) {
    with (evt.attrs) {
        x  = 0;
        y  = 0;
        w  = Desktop.w;
        h  = 64;
        fg = 0xFF00FF00;
    }
}

KLASS window_2 = (Event* evt) {
    with (evt.attrs) {
        x  = 0;
        y  = 0;
        w  = Desktop.w;
        h  = 64;
        fg = 0xFF00FF00;
    }
};

alias KLASS = void function (Event* evt);
