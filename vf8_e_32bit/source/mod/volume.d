module mod.volume;

import app : Event;

struct
Mod_volume (O) {
    O* o;
    static ubyte volume;  

    enum
    Volume_type {
        MUTE,
        LOW,
        MID,
        HIGH,
    }

    void
    VOLUME_MUTE () {
        with (o) {
            ubyte volume = 0;
            //send (VOLUME_INFO, 0);
        }
    }

    void
    VOLUME (Event* evt) {
        with (o) {
            ubyte volume;   
            //send (VOLUME_INFO, volume);
        }
    }

    void
    VOLUME_UP (Event* evt) {  // -5%
        with (o) {
            volume += volume.max / 100 * 5;  
            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME_DN (Event* evt) { // -5%
        with (o) {
            volume -= volume.max / 100 * 5;  
            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME_GET_INFO (Event* evt) {
        with (o) {
            hub.VOLUME_INFO (volume);
        }
    }

    Volume_type
    _volume_type (ubyte volume) {
        with (Volume_type) {
            if (volume == 0)               return MUTE;
            if (volume < volume.max/3)     return LOW;
            if (volume < (volume.max/3)*2) return MID;
            return HIGH;
        }
    }
}
