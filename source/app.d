import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.map          : GO_map;
import vf.input        : Event;
import importc;

import mod.quit   : mod_quit_go = go,go_quit;
import mod.player : mod_player_go = go;
import mod.print  : mod_print_go = go,go_printf;
import mod.send   : mod_send_go = go,go_send;
import mod.ui     : mod_ui_go = go;
import mod.ui : Uni_e;

enum       EVT_APP         = 0x0100;
enum       APP_CODE_QUIT   = 0x0001;
enum ulong EVT_APP_QUIT    = (APP_CODE_QUIT << 16) | EVT_APP;
enum       EVT_UI          = 0x0200;
enum ulong UI_POINTER_IN   = (2             << 16) | EVT_UI;
enum ulong UI_POINTER_OVER = (3             << 16) | EVT_UI;
enum ulong UI_POINTER_OUT  = (4             << 16) | EVT_UI;
enum ulong CLICKED         = (5             << 16) | EVT_UI;
enum ulong OPEN            = (6             << 16) | EVT_UI;
enum ulong DRAW            = (7             << 16) | EVT_UI;
enum ulong PLAY_1          = (8             << 16) | EVT_UI;
enum ulong PLAY_2          = (9             << 16) | EVT_UI;
enum ulong PLAY_3          = (10            << 16) | EVT_UI;


extern(C)
void 
main () {
    tvg_engine_init(4);
        
    O o;
    o.open ();
    // event loop
    o.go (&o,&_app_ego,null,0);
}

void
_app_ego (void* o, void* e, void* evt, REG d) {
    mod_quit_go   (o,e,evt,d);
    mod_player_go (o,e,evt,d);
    mod_ui_go     (o,e,evt,d);
    go_base       (o,e,evt,d);
}

//
alias 
go_base = GO_map!(
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
        (cast(Uni_e*)e).go = &go_base;
    }
}

