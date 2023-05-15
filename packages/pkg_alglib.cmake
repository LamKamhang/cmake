include_guard()

# if alglib has been found
if (TARGET alglib)
  return()
endif()

message(STATUS "[package/alglib]: alglib")

if (NOT ${alglib_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/alglib] does not support version selection.")
endif()

if (NOT DEFINED alglib_TAG)
  set(alglib_TAG "origin/master")
endif()

require_package(alglib "gh:LamKamhang/alglib-cmake-wrapper#${alglib_TAG}")
