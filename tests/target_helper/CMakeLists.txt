cmake_minimum_required(VERSION 3.12)

project(test-target-helper)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)

# example1: no other args.
add_unit(demo1)

# example2: specified source.
add_unit(demo2 SRCS demo1.cc)

# example3: lib.
add_unit(demo.lib isLIB)

# example4: lib with specified source.
add_unit(demo2.lib isLIB SRCS demo.lib.cc)

# example5: target_link_lib.
add_unit(demo.with.lib LIBS demo.lib)
