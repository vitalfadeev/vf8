module mod.sound;


version (X)
struct
Sound {
    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case SOUND_PLAY     : _do_sound_play     (evt); break;
            case SOUND_STOP     : _do_sound_stop     (evt); break;
            case SOUND_GET_INFO : _do_sound_get_info (evt); break;
            default             :
        }
    }

    void
    _do_sound_play (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            send (SOUND_INFO, 1);
        }
    }

    void
    _do_sound_stop (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            send (SOUND_INFO, 0);
        }
    }

    void
    _do_sound_get_info (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            send (SOUND_INFO, 1);
        }
    }

    struct
    Event {
        Type  type;
        ubyte value;

        enum 
        Type {
            SOUND_PLAY,
            SOUND_STOP,
            SOUND_INFO,
            SOUND_GET_INFO,
        }
    }
}

