module bindbc.thorvg.config;

enum TVGSupport {
    noLibrary,
    badLibrary,
    v0_8  = 0x0008,
    v0_9  = 0x0009,
    v0_10 = 0x000A,

    deprecated("use TVGSupport.v0_8 instead") tvg07 = 0x0007
}

version (BindBC_Status) version = BindTVG_Static;
version (BindTVG_Static) enum staticBinding = true;
else enum staticBinding = false;

version (TVG_0_10)     enum tvgSupport = TVGSupport.v0_10;
else version (TVG_0_9) enum tvgSupport = TVGSupport.v0_9;
else                   enum tvgSupport = TVGSupport.v0_8;

