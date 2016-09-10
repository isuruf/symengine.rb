#include "ruby_function.h"

#define IMPLEMENT_ONE_ARG_FUNC(func)                                           \
    VALUE cfunction_##func(VALUE self, VALUE operand1)                         \
    {                                                                          \
        return function_onearg(basic_##func, operand1);                        \
    }

IMPLEMENT_ONE_ARG_FUNC(abs);
IMPLEMENT_ONE_ARG_FUNC(sin);
IMPLEMENT_ONE_ARG_FUNC(cos);
IMPLEMENT_ONE_ARG_FUNC(tan);
IMPLEMENT_ONE_ARG_FUNC(csc);
IMPLEMENT_ONE_ARG_FUNC(sec);
IMPLEMENT_ONE_ARG_FUNC(cot);
IMPLEMENT_ONE_ARG_FUNC(asin);
IMPLEMENT_ONE_ARG_FUNC(acos);
IMPLEMENT_ONE_ARG_FUNC(asec);
IMPLEMENT_ONE_ARG_FUNC(acsc);
IMPLEMENT_ONE_ARG_FUNC(atan);
IMPLEMENT_ONE_ARG_FUNC(acot);
IMPLEMENT_ONE_ARG_FUNC(sinh);
IMPLEMENT_ONE_ARG_FUNC(cosh);
IMPLEMENT_ONE_ARG_FUNC(tanh);
IMPLEMENT_ONE_ARG_FUNC(csch);
IMPLEMENT_ONE_ARG_FUNC(sech);
IMPLEMENT_ONE_ARG_FUNC(coth);
IMPLEMENT_ONE_ARG_FUNC(asinh);
IMPLEMENT_ONE_ARG_FUNC(acosh);
IMPLEMENT_ONE_ARG_FUNC(asech);
IMPLEMENT_ONE_ARG_FUNC(acsch);
IMPLEMENT_ONE_ARG_FUNC(atanh);
IMPLEMENT_ONE_ARG_FUNC(acoth);
IMPLEMENT_ONE_ARG_FUNC(lambertw);
IMPLEMENT_ONE_ARG_FUNC(dirichlet_eta);
IMPLEMENT_ONE_ARG_FUNC(zeta);
IMPLEMENT_ONE_ARG_FUNC(gamma);

#undef IMPLEMENT_ONE_ARG_FUNC

VALUE cfunction_functionsymbol_init(VALUE self, VALUE args)
{
    int argc = RARRAY_LEN(args);
    if (argc == 0) {
        rb_raise(rb_eTypeError, "Arguments Expected");
    }

    VALUE first = rb_ary_shift(args);
    if (TYPE(first) != T_STRING) {
        rb_raise(rb_eTypeError, "String expected as first argument");
    }
    char *name = StringValueCStr(first);

    CVecBasic *cargs = vecbasic_new();

    basic x;
    basic_new_stack(x);
    int i;
    for (i = 0; i < argc - 1; i++) {
        sympify(rb_ary_shift(args), x);
        vecbasic_push_back(cargs, x);
    }

    basic_struct *this;
    Data_Get_Struct(self, basic_struct, this);
    function_symbol_set(this, name, cargs);

    vecbasic_free(cargs);
    basic_free_stack(x);

    return self;
}
