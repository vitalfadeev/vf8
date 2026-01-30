module klass;

import e_class;
import event;


class
Klass {
    string name;
    void* data1;

    void 
    go (Event* evt, E e) {
        with (evt.Type)
        switch (evt.type) {
            case SET_E_PROP :
                _set_e_prop (evt,e);
                break;
            case LAYOUT :
                //_layout (evt,e);
                break;
            case DRAW :
                //_draw (evt,e);
                break;
            default:
        }
    }

    void
    _set_e_prop (Event* evt, E e) {
        //
    }

    override
    string
    toString () {
        return typeof(this).stringof;
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
            _klasses ~= k;
            return this;
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

