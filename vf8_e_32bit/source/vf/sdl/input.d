module vf.sdl.input;

import vf.sdl.glo_input : Glo_input;
import vf.sdl.loc_input : Loc_input;


struct
Input (Event) {
    Loc_input!Event loc_input;
    Glo_input!Event glo_input;

    auto opIndex () { return range; }
    auto opCall ()  { return range; }

    Range
    range () {
        return Range (&this);
    }

    void
    opOpAssign (string op : "~") (Event* evt) {
        loc_input ~= evt;
    }

    //
    struct
    Range {
        Loc_input!Event* loc_input;
        Glo_input!Event* glo_input;
        Source           source;

        this (Input!Event* a) {
            this.loc_input = &a.loc_input;
            this.glo_input = &a.glo_input;
        }

        Event* 
        front () {
            final
            switch (source) with (Source) {
                case LOCAL  : return loc_input.front;
                case GLOBAL : return glo_input.front;
            } 
        };

        bool
        empty () {
            if (!loc_input.empty) { source = Source.LOCAL;  return false; }
            if (!glo_input.empty) { source = Source.GLOBAL; return false; }
            return true;
        }

        void
        popFront () {
            final
            switch (source) with (Source) {
                case LOCAL  : loc_input.popFront (); break;
                case GLOBAL : glo_input.popFront (); break;
            }

        }

        //auto save () { return new this; }

        void
        opOpAssign (string op : "~") (Event* evt) {
            (*loc_input) ~= evt;
        }

        enum
        Source {
            LOCAL,
            GLOBAL,
        }
    }
}
