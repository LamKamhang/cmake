if (NOT DEFINED IGL_DIR)
  set(IGL_DIR ${PROJECT_SOURCE_DIR}/3rd/libigl)
endif()

if (EXISTS ${IGL_DIR})
  message(STATUS "libigl find: ${IGL_DIR}")
  if (NOT TARGET igl)
    add_library(igl INTERFACE)
    target_include_directories(igl
      INTERFACE
      ${IGL_DIR}/include
      ${IGL_DIR}/external/libigl-imgui
      )
  endif()
  set(igl_FOUND TRUE)
else()
  message(WARNING "libigl not found! please set {IGL_DIR} correctly!")
  set(igl_FOUND FALSE)
endif()
