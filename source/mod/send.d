module mod.send;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O_base;
import importc;


void
go (void* o, void* e, void* evt, REG d) {
    //
}

void
go_send (O,int TYP, int COD) (void* o, void* e, void* evt, REG d) {
    printf ("  put Event: 0x%X\n", COD);
    (cast(O*)o).send!(TYP,COD) (o,e,evt,d);
}
