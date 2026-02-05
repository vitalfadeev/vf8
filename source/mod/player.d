module mod.player;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O_base;
import importc;

enum       EVT_UI          = 0x0200;
enum ulong PLAY_1          = (8             << 16) | EVT_UI;
enum ulong PLAY_2          = (9             << 16) | EVT_UI;
enum ulong PLAY_3          = (10            << 16) | EVT_UI;


void
go (Event) (void* o, void* e, Event* evt, REG d) {
    switch (evt.type) {
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
_go_play_1 (Event) = go_play!(Event,1);

alias
_go_play_2 (Event) = go_play!(Event,2);

alias
_go_play_3 (Event)  = go_play!(Event,3);


void
go_play (Event, int resource_id) (void* o, void* e, Event* evt, REG d) {
    printf ("Play %d\n", resource_id);
    with (cast(O*)o) {
        audio.play_wav (resource_id);
    }
}

