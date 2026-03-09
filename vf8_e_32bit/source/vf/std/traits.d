module vf.std.traits;

import std.traits;
import std.meta;


template
Functions (alias T) {
    alias Functions = _Functions!(T,__traits(allMembers, T));
}

template
_Functions (T,MEMBERS...) {
    static if (MEMBERS.length == 0) {
        alias _Functions = AliasSeq!();
    }

    static if (MEMBERS.length == 1) {
        enum  memberName = MEMBERS[0];
        alias member     = __traits(getMember, T, memberName);

        static if (is(typeof(member) == function)) {
            alias _Functions =  AliasSeq!(memberName);
        } else {
            alias _Functions =  AliasSeq!();
        }
    }

    static if (MEMBERS.length > 1) {
        enum  memberName = MEMBERS[0];
        alias member     = __traits(getMember, T, memberName);
        alias rest       = _Functions!(T,MEMBERS[1..$]);

        static if (is(typeof(member) == function)) {
            alias _Functions =  AliasSeq!(memberName,rest);
        } else {
            alias _Functions =  AliasSeq!(rest);
        }
    }
}

// T Functions
//
// alias this _super
//   _super Functions
//
//   alias this _super
//     _super Functions
template
Functions_recursive (alias T) {
    alias _alias_this = __traits (getAliasThis,T);

    static if (_alias_this.length == 0) {
        alias Functions_recursive = Functions!T;
    }

    static if (_alias_this.length >= 1) {
        alias T_ALIAS_THIS = typeof (__traits (getMember, T, _alias_this[0]));
        alias Functions_recursive = 
            NoDuplicates!(
                AliasSeq!(
                    Functions!T,
                    Functions_recursive!T_ALIAS_THIS
                )
            );
    }
}

template
Fn_args_to_varname (string FN,ARGS...) {
    import std.range;
    import std.algorithm;
    import std.meta;
    enum Fn_args_to_varname = "_var_" ~ FN ~ "__" ~ Arg_to_string!ARGS;
}

template
Arg_to_string (ARGS...) {
    import  std.string;

    static if (ARGS.length == 0)
        enum Arg_to_string = "";
    static if (ARGS.length == 1) {
        enum Arg_to_string = ARGS[0].stringof.replace ("*", "_PTR_");
    }
    static if (ARGS.length >= 2) {
        alias rest = ARGS[1..$];
        enum Arg_to_string = ARGS[0].stringof.replace ("*", "_PTR_") ~ "_" ~ Arg_to_string!rest;
    }
}
