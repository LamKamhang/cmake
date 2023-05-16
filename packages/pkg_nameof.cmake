include_guard()

# if nameof::nameof has been found
if (TARGET nameof::nameof)
  return()
endif()

message(STATUS "[package/nameof]: nameof::nameof")


if (NOT DEFINED nameof_VERSION)
  set(nameof_VERSION "0.10.3")
endif()
if (NOT DEFINED nameof_TAG)
  set(nameof_TAG "v${nameof_VERSION}")
endif()

require_package(nameof "gh:Neargye/nameof#${nameof_TAG}"
  CMAKE_ARGS "-DNAMEOF_OPT_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DNAMEOF_OPT_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DNAMEOF_OPT_INSTALL=OFF"
)
