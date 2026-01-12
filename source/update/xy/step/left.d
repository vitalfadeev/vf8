module update.xy.step.left;

void
to_right (This,O,E,Event) (This _this,O o, E e, Event* evt) {
    with (evt.update_xy) {
        _this.canvased.x = cursor.x;
        _this.canvased.y = cursor.y;
        cursor.x        += _this.canvased.w;
        cursor.start_x   = _this.parent.canvased.x;
        cursor.limit_x   = _this.parent.canvased.x + _this.parent.canvased.w;
        if (cursor.x > cursor.limit_x) {
            cursor.y += line_height;  // wrap line
            cursor.x  = cursor.start_x;
        }

        // update total w
        cursor.total_w += _this.canvased.w;
    }
}

