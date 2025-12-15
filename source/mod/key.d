module mod.key;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.map          : GO_map;
import vf.o_base : send;
import vf.o_base : send_d_code;
import vf.input        : Event;
import mod.quit        : go_quit;
import mod.ui          : Uni_e;
import mod.print  : go_printf;
import mod.send   : go_send;
import importc;

enum       EVT_UI          = 0x0200;
enum ulong PLAY_1          = (8             << 16) | EVT_UI;
enum ulong PLAY_2          = (9             << 16) | EVT_UI;
enum ulong PLAY_3          = (10            << 16) | EVT_UI;

alias 
go = GO_map!(
    SDL_KEYDOWN, SDLK_ESCAPE, go_quit!"Quit\n",
    SDL_KEYDOWN, SDLK_LCTRL,  _go_ctrl_pressed,
    SDL_KEYDOWN, SDLK_a,      go_printf!"A! OK!\n",
    SDL_KEYDOWN, SDLK_q,      go_send!(SDL_USEREVENT,PLAY_1),
    SDL_KEYDOWN, SDLK_w,      go_send!(SDL_USEREVENT,PLAY_2),
    SDL_KEYDOWN, SDLK_e,      go_send!(SDL_USEREVENT,PLAY_3),
);

alias 
go_ctrl_pressed = GO_map!(
    SDL_KEYUP,   SDLK_LCTRL, _go_ctrl_released,
    SDL_KEYDOWN, SDLK_a,     go_printf!"CTRL+A\n",
);


//
//alias 
//_go_quit = go_quit!"QUIT\n";

void
_go_ctrl_pressed (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL pressed\n");
        (cast(Uni_e*)e).go = &go_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL released\n");
        (cast(Uni_e*)e).go = go;
    }
}

