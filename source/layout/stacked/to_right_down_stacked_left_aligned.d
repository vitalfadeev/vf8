module layout.stacked.to_right_down_left_aligned;

import layout.xy;


// 0,0 .. w,h
void
to_right_down_left_aligned (E) (E _this) {
    XY cursor;
    XY space = _this.childs_space;
    XY line  = _this.wh;
    XY limi  = _this.wh;

    foreach (_e; _this.childs) {
        // each e h = line h
        _e.wh.y = line.y;
        //
        auto wh = _e.wh;
        auto cn = line_step_and_check_overflow (cursor,wh,space,line);
        _e.xy  = cn.cur;
        cursor = cn.next;
    }
}

Cur_next
line_step_and_check_overflow (XY cursor, XY size, XY space, XY limi) {
    auto next = step (cursor,space,size);
    if (is_overflow (next,limi)) {
        cursor = new_line (next,space,size);
        next   = step (cursor,size);
    }

    return Cur_next (cursor,next);
}

struct
Cur_next {
    XY cur;
    XY next;
}

XY
step (XY cursor, XY space, XY size) {
    auto next = cursor;
    next.x += space.x;
    next.x += size.x;
    return next;
}

XY
step (XY cursor, XY size) {
    auto next = cursor;
    next.x += size.x;
    return next;
}

bool
is_overflow (XY next, XY limi) {
    return (next.x > limi.x);
}

XY
new_line (XY next, XY space, XY size) {
    next.x  = 0;
    next.y += space.y + size.y;
    return next;
}
