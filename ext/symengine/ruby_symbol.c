#include "ruby_symbol.h"

VALUE csymbol_init(VALUE self, VALUE name_or_id)
{
    const char *str_ptr;

    switch (TYPE(name_or_id)) {
        case T_STRING:
            str_ptr = StringValueCStr(name_or_id);
            break;
        case T_SYMBOL:
            str_ptr = rb_id2name(rb_to_id(name_or_id));
            break;
        default:
            str_ptr = "Fix for clang warning";
            rb_raise(rb_eTypeError,
                     "wrong argument type %s (expected Symbol or String)",
                     rb_obj_classname(name_or_id));
    }

    basic_struct *this;
    Data_Get_Struct(self, basic_struct, this);

    symbol_set(this, str_ptr);

    return self;
}
