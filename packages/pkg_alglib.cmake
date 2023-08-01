include_guard()

# if alglib has been found
if (TARGET alglib)
  if (NOT TARGET alglib::alglib)
    add_library(alglib::alglib ALIAS alglib)
  endif()
  return()
endif()

message(STATUS "[package/alglib]: alglib")

if (NOT ${alglib_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/alglib] does not support version selection.")
endif()

if (NOT DEFINED alglib_TAG)
  set(alglib_TAG "origin/master")
endif()

require_package("gh:LamKamhang/alglib-cmake-wrapper#${alglib_TAG}"
  NAME alglib
)
