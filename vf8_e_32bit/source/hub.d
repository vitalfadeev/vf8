import vf.std.traits : Functions;

import std.traits;
import std.string;
import std.stdio : writeln;


struct
Hub {
    Rec[string] s;  // by name, by types

    void
    register (T) (T* t) {
        foreach (fn_name; Functions!T) {
            if (fn_name != fn_name.toUpper) continue;

            Typed typed;
            typed.length = Parameters!(__traits(getMember,T,fn_name)).length;
            foreach(i,par; Parameters!(__traits(getMember,T,fn_name))) {
                typed.s[i] = typeid (par);
            }
            typed.dg = cast (DG) &__traits(getMember,t,fn_name); // delegate

            auto rec = fn_name in s;
            if (rec !is null)
                rec.typeds ~= typed;
            else
                s[fn_name] = Rec([typed]);
        }
    }

    void
    opDispatch (string name, ARGS...) (ARGS args) {
        pragma (msg, "opDispatch: ", name, " ", ARGS);
        Typed typed;
        typed.length = ARGS.length;
        foreach(i,par; ARGS) {
            typed.s[i] = typeid (par);
        }

        bool found = false;
        auto _rec = name in s;
        if (_rec !is null) {
            foreach (ref _typed; _rec.typeds) {
                if (_typed == typed) {
                    (cast (void delegate (ARGS)) _typed.dg) (args);
                    found = true;
                }
            }
        }

        if (!found) {
            //assert (0, "Not found delegate for "~name~" ("~ARGS.stringof~")");
        }
    }

    struct
    Rec {
        Typed[] typeds;
    }
    struct
    Typed {
        size_t           length;
        TypeInfo[8]      s; // max 8 types
        DG               dg;

        bool
        opEquals (Typed b) {
            if (this.length != b.length)
                return false;
            for (auto i=0; i < this.length; i++)
                if (this.s[i] != b.s[i])
                    return false;

            return true;
        }
    }

    alias DG = void delegate ();
}


