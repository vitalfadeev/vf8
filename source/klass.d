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

