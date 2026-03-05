import vf.std.traits : Functions;

import std.traits;
import std.string;
import std.stdio : writeln;
import std.format : format;
import std.stdio : writefln;


struct
Hub {
    Rec[string] s;  // by name, by types

    void
    register (T) (T* t) {
        writeln ("register: ", T.stringof);
        foreach (fn_name; Functions!T) {
            if (fn_name != fn_name.toUpper) continue;

            writeln ("  ", fn_name);

            Typed typed;
            foreach(par; Parameters!(__traits(getMember,T,fn_name))) {
                typed.s ~= typeid (par);
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
    unregister (T) (T* t) {
        foreach (ref _rec; s) {
            foreach (ref _typed; _rec.typeds) {
                if (_typed.dg.ptr == t) {
                    // remove _typed
                }
            }
        }
    }

    void
    opDispatch (string name, ARGS...) (ARGS args) {
        pragma (msg, "opDispatch: ", name, " ", ARGS);
        writeln (name, " ", ARGS.stringof, ": ", args);

        // init
        Typed typed;
        foreach (par; ARGS) {
            typed.s ~= typeid (par);
        }

        // do
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

        // info
        if (!found) {
            //assert (0, name~ " "~ ARGS.stringof~ ", no listener ");
            writeln (name, " ", ARGS.stringof, ", no listener ");
        }
    }


    struct
    Rec {
        Typed[] typeds;
    }

    struct
    Typed {
        TypeInfo[] s; // max 8 types
        DG         dg;

        bool
        opEquals (Typed b) {
            if (this.s.length != b.s.length)
                return false;
            for (auto i=0; i < this.s.length; i++)
                if (this.s[i] != b.s[i])
                    return false;

            return true;
        }
    }

    alias DG = void delegate ();
}


