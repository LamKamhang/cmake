include_guard()

if (TARGET fmt::fmt)
  return()
endif()

message(STATUS "[package/fmt]: fmt::fmt")
set(fmt_VERSION 9.1.0 CACHE STRING "fmt customized version.")

require_package(fmt "gh:fmtlib/fmt#${fmt_VERSION}"
  CMAKE_ARGS "-DFMT_DOC=OFF"
  CMAKE_ARGS "-DFMT_INSTALL=OFF"
  CMAKE_ARGS "-DFMT_TEST=OFF"
)
