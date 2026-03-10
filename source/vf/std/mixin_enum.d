module vf.std.mixin_enum;


mixin template
Enum (string name, ushort start_value, Pairs...) {
    import vf.std.mixin_enum : mods_enum_members;
    import std.format : format;

    mixin ("enum "~name~" :ushort {"~
        format!"_ = %d,\n" (start_value)~
        mods_enum_members!(Pairs).result~
        "}");
}

template 
mods_enum_members (Pairs...) {
    import std.meta : AliasSeq;

    static if (Pairs.length == 0) {
        enum result = "";
    }
    else static if (Pairs.length >= 2) {
        enum Mod    = Pairs[0];
        enum Enu    = Pairs[1];

        enum rest   = mods_enum_members!(Pairs[2 .. $]).result;
        enum result = mod_enum_members!(Mod,Enu) ~ rest;
    }
    else {
        static assert(0, "Количество элементов в AliasSeq должно быть >= 3");
    }
}

string
mod_enum_members (string _module, string _enum) () {
    string s;
    mixin ("import "~_module~";");
    mixin ("s = enum_members!("~_enum~") ();");
    return s;
}

string
enum_members (T) () {
    import std.traits : EnumMembers;
    import std.conv   : to;

    string s;
    foreach (i,member; EnumMembers!T)  {
        //s ~= __traits(identifier,EnumMembers!T[i]) ~ " = " ~ (cast(uint)member).to!string ~ ",\n";
        s ~= __traits(identifier,EnumMembers!T[i]) ~ ",\n";
    }
    return s;
}
