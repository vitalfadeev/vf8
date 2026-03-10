module vf.std.tstring256;


struct
Tstring256 (T,size_t N=ubyte.max)  {
struct {
//    align (T.sizeof): 
    ubyte  length;
    ubyte  n = N;  // capacity
}    
    T[N+1] s;  // 0-element is length

    auto ref opIndex (ubyte i)  { return s[i]; }
    ubyte index_of (T* ptr)  { return cast (ubyte) (ptr - s.ptr); }
    auto  limit ()           { return s.ptr + n; }
    auto  llimit ()          { return s.ptr + length; }
    auto  range ()           { return Range (&this,s.ptr); }
    auto  range (T* a)       { return Range (&this,a); }
    auto  move_right_1 (T* src) {
        assert (src >= s.ptr);
        assert (src  < limit);
        assert (length >= 2);
        // check
        if (length == 0) return;  // nothing to move
        if (length == 1) return;  // nothing to move
        // move last 1 (with check limit)
        T* _ptr = llimit - 1 - 1;
        // move tail
        for (; _ptr >= src; _ptr--) {  // right to left
            *(_ptr+1) = *_ptr;         // move 1
        }
    }

    struct
    Range {
        Tstring256!T* _this;
        T*   front;
        auto empty ()             { return front >= _this.llimit; }  // front == limit == ptr + length
        void popFront ()          { front++; }
        void popFrontN (size_t n) { front += n; }
    }
}
