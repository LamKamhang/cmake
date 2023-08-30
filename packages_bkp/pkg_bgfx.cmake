include_guard()

# if bgfx has been found
if (TARGET bgfx)
  return()
endif()

message(STATUS "[package/bgfx]: bgfx bimg bx")
option(BGFX_WITH_GLFW "bgfx build with glfw" ON)

if (NOT ${bgfx_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/bgfx] does not support version selection.")
endif()

if (NOT DEFINED bgfx_TAG)
  set(bgfx_TAG "v1.118.8455-425")
endif()

require_package("gh:bkaradzic/bgfx.cmake.git#${bgfx_TAG}"
  NAME bgfx
)
