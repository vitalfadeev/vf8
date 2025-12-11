module bindbc.thorvg;

public import bindbc.thorvg.config,
              bindbc.thorvg.bind;

version (BindTVG_Static) {}
else public import bindbc.thorvg.dynload;
