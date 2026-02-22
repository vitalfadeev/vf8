module mod.volume;


version (X)
struct
Volume {
    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case VOLUME_MUTE     : _do_volume_mute (evt); break;
            case VOLUME          : _do_volume      (evt); break;
            case VOLUME_UP       : _do_volume_up   (evt); break;
            case VOLUME_DN       : _do_volume_dn   (evt); break;
            case VOLUME_GET_INFO : _do_volume_info (evt); break;
            default              :
        }
    }

    enum
    Type {
        MUTE,
        LOW,
        MID,
        HIGH,
    }

    void
    _do_volume_mute (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            ubyte volume = 0;
            send (VOLUME_INFO, 0);
        }
    }

    void
    _do_volume (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            ubyte volume;   
            send (VOLUME_INFO, volume);
        }
    }

    void
    _do_volume_up (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            ubyte volume;  // +5%
            send (VOLUME_INFO, volume);
        }
    }

    void
    _do_volume_dn (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            ubyte volume;  // -5%
            send (VOLUME_INFO, volume);
        }
    }

    void
    _do_volume_get_info (Event* evt) {
        with (evt.o)
        with (Event.Type) {
            ubyte volume;   
            send (VOLUME_INFO, volume);
        }
    }

    Type
    _volume_type (ubyte volume) {
        with (Type) {
            if (volume == 0)               return MUTE;
            if (volume < volume.max/3)     return LOW;
            if (volume < (volume.max/3)*2) return MID;
            return HIGH;
        }
    }

    struct
    Event {
        Type        type;
        ubyte       volume;
        Volume.Type volume_type;

        enum 
        Type {
            VOLUME_MUTE,
            VOLUME,
            VOLUME_UP,
            VOLUME_DN,
            VOLUME_INFO,
            VOLUME_GET_INFO,
        }
    }
}
