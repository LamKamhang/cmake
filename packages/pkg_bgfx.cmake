include_guard()

# if bgfx has been found
if (TARGET bgfx)
  return()
endif()

message(STATUS "[package/bgfx]: bgfx")

if (NOT ${bgfx_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/bgfx] does not support version selection.")
endif()

if (NOT DEFINED bgfx_TAG)
  set(bgfx_TAG "v1.118.8455-425")
endif()

lam_add_package(
  "gh:bkaradzic/bgfx.cmake.git#${bgfx_TAG}"
  NAME bgfx
  # for user customize.
  ${bgfx_USER_CUSTOMIZE_ARGS}
)
