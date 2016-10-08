set(RUBY_WRAPPER_SRC
    ruby_basic.c
    ruby_symbol.c
    ruby_number.c
    ruby_integer.c
    ruby_real_double.c
    ruby_real_mpfr.c
    ruby_complex.c
    ruby_complex_double.c
    ruby_complex_mpc.c
    ruby_constant.c
    ruby_function.c
    ruby_ntheory.c
    ruby_utils.c
    symengine_utils.c
    symengine.c
    )

include_directories(BEFORE ${RUBY_INCLUDE_DIRS})

add_library(symengine_ruby SHARED ${RUBY_WRAPPER_SRC})
target_link_libraries(symengine_ruby ${SYMENGINE_LIBRARIES} ${RUBY_LIBRARY})
set_target_properties(symengine_ruby PROPERTIES
                        PREFIX ""
                        OUTPUT_NAME "symengine"
                        LIBRARY_OUTPUT_DIRECTORY "${ruby_wrapper_BINARY_DIR}/lib/symengine"
                     )

# Ruby gems require a install target.
install(TARGETS symengine_ruby
            RUNTIME DESTINATION lib/symengine
            ARCHIVE DESTINATION lib/symengine
            LIBRARY DESTINATION lib/symengine
        )
