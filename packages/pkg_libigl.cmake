include_guard()

# if igl::core has been found.
if (TARGET igl::core)
  return()
endif()

message(STATUS "[package/libigl]: igl::core")

set(libigl_VERSION 2.4.0 CACHE STRING "libigl customized version.")

require_package(libigl "gh:libigl/libigl#v${libigl_VERSION}")
