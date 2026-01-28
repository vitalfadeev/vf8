module mod.key;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.map          : GO_map;
import mod.quit        : go_quit;
import mod.print  : go_printf;
import mod.send   : go_send;
import importc;

alias 
go (O,Event) = GO_map!(
    Event,
    SDL_KEYDOWN, SDLK_ESCAPE, go_quit!("Quit\n",O!Event),
    SDL_KEYDOWN, SDLK_LCTRL, _go_ctrl_pressed!O,
    SDL_KEYDOWN, SDLK_a,      go_printf!"A! OK!\n",
    SDL_KEYDOWN, SDLK_q,      go_send!(O!Event,SDL_USEREVENT,PLAY_1),
    SDL_KEYDOWN, SDLK_w,      go_send!(O!Event,SDL_USEREVENT,PLAY_2),
    SDL_KEYDOWN, SDLK_e,      go_send!(O!Event,SDL_USEREVENT,PLAY_3),
);

alias 
go_ctrl_pressed (Event) = GO_map!(
    Event,
    SDL_KEYUP,   SDLK_LCTRL, _go_ctrl_released,
    SDL_KEYDOWN, SDLK_a,     go_printf!"CTRL+A\n",
);


//
//alias 
//_go_quit = go_quit!"QUIT\n";

void
_go_ctrl_pressed (O) (O* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL pressed\n");
        (cast(Uni_e*)e).go = &go_ctrl_pressed;
    }
}

void
_go_ctrl_released (O) (O* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL released\n");
        (cast(Uni_e*)e).go = go;
    }
}

