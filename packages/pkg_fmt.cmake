include_guard()

# if fmt::fmt has been found
if (TARGET fmt::fmt)
  return()
endif()

message(STATUS "[package/fmt]: fmt::fmt")


if (NOT DEFINED fmt_VERSION)
  set(fmt_VERSION "9.1.0")
endif()
if (NOT DEFINED fmt_TAG)
  set(fmt_TAG "${fmt_VERSION}")
endif()

require_package(fmt "gh:fmtlib/fmt#${fmt_TAG}"
  CMAKE_ARGS "-DFMT_DOC=OFF"
  CMAKE_ARGS "-DFMT_INSTALL=OFF"
  CMAKE_ARGS "-DFMT_TEST=OFF"
)
