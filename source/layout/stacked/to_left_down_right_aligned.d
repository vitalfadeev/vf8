module layout.stacked.to_left_down_right_aligned;

import layout.xy;


// 0,0 .. w,h
void
to_left_down_right_aligned (E) (E _this) {
    XY cursor;
    XY space = _this.childs_space;
    XY line  = _this.wh;
    XY limi  = _this.wh;
    XY total;
    cursor.x = limi.x;

    // setup
    foreach (_e; _this.childs) {
        // each e h = line h
        _e.wh.y = line.y;
        //
        auto wh = _e.wh;
        auto cn = line_step_and_check_overflow (cursor,wh,space,line);
        _e.xy  = cn.cur;
        cursor = cn.next;
        total.w  = total.w + wh.w;
        total.h  = (cursor.h > total.h) ? cursor.h : total.h;
    }

    // translate
    auto dx = _this.xy.x + _this.wh.w - total.w;
    foreach (_e; _this.childs) {
        _e.xy.x += dx;
    }
}

Cur_next
line_step_and_check_overflow (XY cursor, XY size, XY space, XY limi) {
    auto next = step (cursor,space,size);
    if (is_overflow (next,limi)) {
        cursor = new_line (next,space,size,limi);
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
    next.x -= space.x;
    next.x -= size.x;
    return next;
}

XY
step (XY cursor, XY size) {
    auto next = cursor;
    next.x -= size.x;
    return next;
}

bool
is_overflow (XY next, XY limi) {
    return (next.x < 0);
}

XY
new_line (XY next, XY space, XY size, XY limi) {
    next.x  = limi.x;
    next.y += space.y;
    next.y += size.y;
    return next;
}
