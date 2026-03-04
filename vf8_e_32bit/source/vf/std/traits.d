module vf.std.traits;

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
