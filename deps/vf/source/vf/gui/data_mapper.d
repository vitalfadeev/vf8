module vf.gui.data_mapper;


mixin template
Data_mapper_tpl (Klass,Event,E) {
    Data_mapper_fn data_mapper;
    alias Data_mapper_fn = void function (Klass k, Event* evt, E e, void* data);
}
