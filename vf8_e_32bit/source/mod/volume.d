module mod.volume;

import app : o;

struct
Volume {
    ubyte volume;
    ubyte unmuted_volume;
    bool  muted;

    void
    VOLUME_MUTE () {
        with (o) {
            if (muted) return;

            unmuted_volume = volume;
            volume = 0;
            muted = true;
            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME_UNMUTE () {
        with (o) {
            if (!muted) return;

            volume = unmuted_volume;
            muted = false;
            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME () {
        with (o) {
            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME_UP () {  // +5%
        with (o) {
            auto d = (volume.max / 100 * 5);
            auto able = volume.max - volume;
            if (able > d) {
                volume += d;
            } else {
                volume = volume.max;
            }
            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME_DN () { // -5%
        with (o) {
            auto d = (volume.max / 100 * 5);
            if (volume > d) {
                volume -= d;
            } else {
                volume = volume.min;
            }
            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME_GET_INFO () {
        with (o) {
            hub.VOLUME_INFO (volume);
        }
    }
}
