include_gurad()

# if nameof::nameof has been found
if (TARGET nameof::nameof)
  return()
endif()

message(STATUS "[package/nameof]: nameof::nameof")

set(nameof_VERSION 0.10.3 CACHE STRING "nameof customized version")

require_package(nameof "gh:Neargye/nameof.git#{nameof_VERSION}"
  CMAKE_ARGS "-DNAMEOF_OPT_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DNAMEOF_OPT_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DNAMEOF_OPT_INSTALL=OFF"
)
