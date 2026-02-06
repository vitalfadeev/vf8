module vf.base.o;

import vf.base.input : Input;
import vf.base.send  : Send;

///
struct
O (Event) {
    Input!Event _input;
    auto         input () { return _input.range; };
    GO           go;

    alias GO = void function (void* o, Event* evt);

    this (GO go) {
        this.go = go;
    }

    mixin Send!Event;
}
