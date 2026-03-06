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
        writeln ("register: ", T.stringof, " ", t);
        Typed typed;
        Rec*  rec;
        static foreach (fn_name; Functions!T) {
            static if (fn_name == fn_name.toUpper) {
                writeln ("  ", fn_name);

                typed.s.length = Parameters!(__traits(getMember,T,fn_name)).length;
                static foreach(i,par; Parameters!(__traits(getMember,T,fn_name))) {
                    typed.s[i] = typeid (par);
                }
                typed.dg = cast (DG) &__traits(getMember,t,fn_name); // delegate

                rec = fn_name in s;
                if (rec !is null)
                    rec.typeds ~= typed;
                else
                    s[fn_name] = Rec([typed]);
            }

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
        static if (ARGS.length)
            writeln ("  ", name, " ", ARGS.stringof, " ", args);
        else
            writeln ("  ", name, " ", ARGS.stringof);

        // init
        Typed typed;
        typed.s.length = ARGS.length;
        static foreach (i,par; ARGS) {
            typed.s[i] = typeid (par);
        }

        // do
        bool found = false;

        auto _rec = name in s;
        if (_rec !is null)
        foreach (ref _typed; _rec.typeds) {
            if (_typed == typed) {
                writeln ("    DO ", _typed.dg.ptr);
                (cast (void delegate (ARGS)) _typed.dg) (args);
                found = true;
            }
        }

        // info
        if (!found) {
            //assert (0, name~ " "~ ARGS.stringof~ ", no listener ");
            writeln ("  ", name, " ", ARGS.stringof, ", no listener ");
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


