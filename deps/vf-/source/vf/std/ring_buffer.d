module vf.std.ring_buffer;

struct
Ring_buffer (T,size_t N) {
    T[N]   s;
    size_t front_i;
    size_t back_i;
    T*   front () { return &s[front_i]; };
    bool empty () { return front_i == back_i; }
    void popFront () {
        front_i++;
        if (front_i == N)
            front_i = 0;
    }

    void
    opOpAssign (string op : "~") (T* t) {
        s[back_i] = *t;
        back_i++;
        if (back_i == N)
            back_i = 0;
    }
}
