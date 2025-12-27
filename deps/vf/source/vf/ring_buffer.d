module vf.ring_buffer;

struct
Ring_buffer (T,size_t N) {
    T[N] s;
    T* a;
    T* b;
    T* limit;

    void
    open () {
        a = b = s.ptr;
        limit = s.ptr+s.length;
    }

    void
    get (T* t) {
        // T[a..b]
        assert (a != b);
        *t = *a;
        a++;
        if (a == limit)
            a = s.ptr;
    }

    void
    put (T* t) {
        // T[a..b]
        assert (b != a);
        *b = *t;
        b++;
        if (b == limit)
            b = s.ptr;
    }

    void
    put (ref T t) {
        // T[a..b]
        assert (b != a);
        *b = t;
        b++;
        if (b == limit)
            b = s.ptr;
    }

    bool
    empty () {
        return a == b;
    }
}