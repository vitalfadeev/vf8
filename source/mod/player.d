module mod.player;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.input        : Event;
import importc;

enum       EVT_UI          = 0x0200;
enum ulong PLAY_1          = (8             << 16) | EVT_UI;
enum ulong PLAY_2          = (9             << 16) | EVT_UI;
enum ulong PLAY_3          = (10            << 16) | EVT_UI;


void
go (void* o, void* e, void* evt, REG d) {
    auto _evt = cast (Event*) evt;
    REG   typ = _evt.type;

    switch (typ) {
        case SDL_USEREVENT:
            switch (_evt.user.code) {
                case PLAY_1: 
                    printf ("on PLAY_1\n");
                    _go_play_1 (o,e,evt,d);
                    break;
                case PLAY_2: 
                    printf ("on PLAY_2\n");
                    _go_play_2 (o,e,evt,d);
                    break;
                case PLAY_3: 
                    printf ("on PLAY_3\n");
                    _go_play_3 (o,e,evt,d);
                    break;
                default:
            }
            break;
        default:
    }
}

alias
_go_play_1 = go_play!(1);

alias
_go_play_2 = go_play!(2);

alias
_go_play_3 = go_play!(3);


void
go_play (int resource_id) (void* o, void* e, void* evt, REG d) {
    printf ("Play %d\n", resource_id);
    with (cast(O*)o) {
        audio.play_wav (resource_id);
    }
}

