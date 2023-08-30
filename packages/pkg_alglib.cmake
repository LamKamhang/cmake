include_guard()

# if alglib has been found
if (TARGET alglib)
  if (NOT TARGET alglib::alglib)
    add_library(alglib::alglib ALIAS alglib)
  endif()
  return()
endif()

message(STATUS "[package/alglib]: alglib")

if (NOT DEFINED alglib_VERSION)
  # previous version: 3.20.0
  set(alglib_VERSION "4.00.0")
endif()
if (NOT DEFINED alglib_TAG)
  set(alglib_TAG "alglib-${alglib_VERSION}.cpp.gpl.zip")
endif()

if (alglib_USE_PREBUILD)
  message(WARNING "alglib currently does not support prebuild.")
endif()

# TODO: move it to a standalone project to enable installing.
lam_add_package(
  "https://www.alglib.net/translator/re/${alglib_TAG}"
  NAME alglib
)

file(GLOB headers "${alglib_SOURCE_DIR}/src/*.h")
file(GLOB sources "${alglib_SOURCE_DIR}/src/*.cpp")

add_library(alglib ${headers} ${sources})
add_library(alglib::alglib ALIAS alglib)
