cmake_minimum_required(VERSION 3.0)
if (NOT DEFINED STB_DIR)
  set(STB_DIR ${PROJECT_SOURCE_DIR}/3rd/stb)
endif()

if (EXISTS ${STB_DIR})
  message(STATUS "stb find: ${STB_DIR}")
  if (NOT TARGET stb)
    add_library(stb ${PROJECT_SOURCE_DIR}/cmake/stb_impl.cc)

    target_compile_definitions(stb PRIVATE STB_IMAGE_IMPLEMENTATION)
    target_compile_definitions(stb PRIVATE STB_IMAGE_WRITE_IMPLEMENTATION)

    target_include_directories(stb
      PUBLIC
      ${STB_DIR}
      )
  endif()
  set(stb_FOUND TRUE)
else()
  message(WARNING "stb not found! please set {STB_DIR} correctly!")
  set(stb_FOUND FALSE)
endif()
