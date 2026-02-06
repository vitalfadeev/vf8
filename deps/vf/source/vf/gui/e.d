module vf.gui.e;

version (GUI):
import vf.gui.childs_parent;
version (KLASSES) import vf.gui.klass;
import vf.gui.attrs;
import vf.gui.layout;
import vf.gui.on;

//
struct
E {
    mixin Childs_parent!E;  // parent,l,r,cl,cr
    version (FIXED_LAUOUT) int   x,y,w,h;
    version (FIXED_LAUOUT) uint  fg,bg;
    version (ON)           alias Event_type = uint;
    version (ON)           mixin On!Event_type;
    
    version (KLASSES) mixin Klasses_tpl;     // klasses
    version (LAUOUT)  mixin Attrs;          // x,y,w,h,childs_layout,fg,bg,hotkey,img,text,
    version (LAUOUT)  mixin Layout_tpl!E;   // xy, childs_space

    //mixin Event_draw.tpl;
    //mixin Event_click.tpl;

    //string
    //toString () {
    //    string s;
    //    s = typeof(this).stringof ~ "(";
    //    foreach (k; klasses) {
    //        s ~= " " ~ k.toString;
    //    }
    //    s ~= ")";
    //    return s;
    //}
}


version (NEVER):
void
dump_tree (E* e) {
    import core.stdc.stdio : printf;
    import std.string : toStringz;

    foreach (_e; e.childs_recursive) {
        for (auto i = _e.level; i > 0; i--)  printf ("  ");
        printf ("e");
        foreach (k; _e.klasses) printf (" %s", k.toString.toStringz);
        //printf (" wh=(%dx%d), c.wh:(%1.1f,%1.1f) , c.xy:(%1.1f,%1.1f)", 
        //    _e.w.type,     _e.h.type,  
        //    _e.wh.w, _e.wh.h,
        //    _e.xy.x, _e.xy.y);
        printf ("\n");
    }
}

uint
level (E* e) {
    uint a;
    for (;e !is null; e = e.parent )
        a++;
    return a;
}

void
dump_tree2 (E* e, int level=0) {
    import core.stdc.stdio : printf;

    if (e is null) return;

    // e
    for (auto i = level; i > 0; i--)  printf ("  ");
    printf ("e");
    // klasses
    foreach (k; e.klasses) printf (" %s", k.toString.toStringz);
    // properties
    //printf (" wh=(%dx%d), c.wh:(%1.1f,%1.1f) , c.xy:(%1.1f,%1.1f)", 
    //    e.w.type,     e.h.type,  
    //    e.wh.w, e.wh.h,
    //    e.xy.x, e.xy.y);
    printf ("\n");

    // childs
    foreach (_e; e.childs)
        dump_tree2 (_e,level+1);
}
