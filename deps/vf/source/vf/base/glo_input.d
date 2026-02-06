module vf.base.glo_input;


struct
Glo_input (Event) {
    Event* front;
    bool   empty=true;
    void   popFront () {}
}
