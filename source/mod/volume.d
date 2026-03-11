module mod.volume;

import vf.sdl.importc_sdl_mixer;
import std.conv : to;
import app : o;

//alias MIX_MAX_VOLUME = SDL_MIX_MAXVOLUME;

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
            //auto _sdl_volume = MIX_MAX_VOLUME * volume / volume.max;
            //Mix_MasterVolume (_sdl_volume);

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

            //auto _sdl_volume = MIX_MAX_VOLUME * volume / volume.max;
            //Mix_MasterVolume (_sdl_volume);
            //Mix_VolumeMusic ();

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

            //auto _sdl_volume = MIX_MAX_VOLUME * volume / volume.max;
            //Mix_MasterVolume (_sdl_volume);

            hub.VOLUME_INFO (volume);
        }
    }

    void
    VOLUME_GET_INFO () {
        with (o) {
            //int _sdl_volume = Mix_MasterVolume(-1);
            //volume = (volume.max * _sdl_volume / MIX_MAX_VOLUME).to!ubyte;

            hub.VOLUME_INFO (volume);
        }
    }
}
