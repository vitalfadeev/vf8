module mod.send;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.o_base       : send;
import vf.input        : Event;
import importc;


void
go (void* o, void* e, void* evt, REG d) {
    //
}

void
go_send (int TYP, int COD) (void* o, void* e, void* evt, REG d) {
    printf ("  put Event: 0x%X\n", COD);
    send!(TYP,COD) (o,e,evt,d);
}
