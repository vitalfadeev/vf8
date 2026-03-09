module vf.std.vars;

import vf.std.traits : Fn_args_to_string;

struct
Vars (T) {
    T*
    var (string name, ARGS...) () {
        static __gshared T _var;
        return &_var;
    }
}

struct
Vars2 (T) {
    T[string] _var;

    T*
    var (string name, ARGS...) () {
        string name_ARGS = Fn_args_to_string!(name,ARGS);
        auto t = name_ARGS in _var;
        if (t is null)
            _var[name_ARGS] = T.init;
        return &_var[name_ARGS];
    }
}

