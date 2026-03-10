module hub;

import vf.std.traits : Functions_recursive;
import vf.std.vars : Vars;
import std.traits;
import std.string;
import std.traits;
import std.conv;
import std.algorithm;
import std.stdio  : writeln;
import std.format : format;
import std.stdio  : writefln;


struct
Hub {
    Vars!(DG[]) _vars;

    alias DG = void delegate ();

    void
    register (T) (T t) if (is (T == class)) {
        //
    }

    void
    register (T) (T* t) if (is (T == struct)) {
        writeln ("register: ", T.stringof, " ", t);

        DG[]* _dgs;
        static foreach (name; Functions_recursive!T) {
            //static if (isDelegate!(__traits(getMember,T,fn_name)))
            static if (!__traits(isStaticFunction, __traits(getMember,T,name)))
            static if (name == name.toUpper) {
                writeln ("  ", name, " ", Parameters!(__traits(getMember,T,name)).stringof);

                _dgs = _vars.var!(name,Parameters!(__traits(getMember,T,name)));
                (*_dgs) ~= cast (DG) &__traits(getMember,t,name); // delegate
            }
        }
    }

    void
    unregister (T) (T t)  if (is (T == class)) {
        //
    }

    void
    unregister (T) (T* t)  if (is (T == struct)) {
        writeln ("unregister: ", T.stringof, " ", t);

        DG[]* _dgs;
        static foreach (name; Functions_recursive!T) {
            static if (!__traits(isStaticFunction, __traits(getMember,T,name)))
            static if (name == name.toUpper) {
                writeln ("  ", name, " ", Parameters!(__traits(getMember,T,name)).stringof);

                _dgs = _vars.var!(name,Parameters!(__traits(getMember,T,name))) ();
                size_t[] for_remove;
                foreach (i,_dg; *_dgs) {
                    if (_dg.ptr == t) {
                        for_remove ~= i;
                    }
                }
                if (for_remove.length > 0)
                    (*_dgs) = (*_dgs).remove (for_remove);
            }
        }
    }

    void
    opDispatch (string name, ARGS...) (ARGS args) if (name == name.toUpper) {
        pragma (msg, "opDispatch: ", name, " ", ARGS);
        static if (ARGS.length)
            writeln ("  ", name, " ", ARGS.stringof, " ", args);
        else
            writeln ("  ", name, " ", ARGS.stringof);

        // delegates for name,args
        DG[]* _dgs = _vars.var!(name,ARGS) ();

        // do
        if ((*_dgs).length > 0) {
            foreach (dg; *_dgs) {
                (cast (void delegate (ARGS)) dg) (args);
            }
        }
        // info
        else {
            //assert (0, name~ " "~ ARGS.stringof~ ", no listener ");
            writeln ("  ", name, " ", ARGS.stringof, ", no listener ");
        }
    }
}

