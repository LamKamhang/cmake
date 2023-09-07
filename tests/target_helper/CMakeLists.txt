cmake_minimum_required(VERSION 3.12)

project(test-target-helper)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)

# example1: no other args.
lam_add_target(demo1)

# example2: specified source.
lam_add_target(demo2 SRCS demo1.cc)

# example3: lib.
lam_add_target(demo.lib isLIB)

# example4: lib with specified source.
lam_add_target(demo2.lib isLIB SRCS demo.lib.cc)

# example5: target_link_lib.
lam_add_target(demo.with.lib LIBS demo.lib)

# example6: interface.
lam_add_target(demo.interface INTERFACE
  LIBS demo.lib
  FEATS std_cxx_17)
