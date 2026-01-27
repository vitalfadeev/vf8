module vf.ring_buffer;

struct
Ring_buffer (T,size_t N) {
    T[N] s;
    T* a;
    T* b;
    T* limit;
    size_t n;

    void
    open () {
        a = b = s.ptr;
        limit = s.ptr+s.length;
        n = 0;
    }

    void
    get (T* t) {
        // T[a..b]
        assert (n > 0);
        *t = *a;
        a++;
        if (a == limit)
            a = s.ptr;
        n--;
    }

    void
    put (T* t) {
        // T[a..b]
        assert (n < N);
        *b = *t;
        b++;
        if (b == limit)
            b = s.ptr;
        n++;
    }

    void
    put (ref T t) {
        // T[a..b]
        assert (n < N);
        *b = t;
        b++;
        if (b == limit)
            b = s.ptr;
        n++;
    }

    bool
    empty () {
        return n == 0;
    }
}